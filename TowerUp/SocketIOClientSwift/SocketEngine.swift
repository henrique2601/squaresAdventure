//
//  SocketEngine.swift
//  Socket.IO-Client-Swift
//
//  Created by Erik Little on 3/3/15.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

public final class SocketEngine: NSObject, WebSocketDelegate {
    private typealias Probe = (msg: String, type: PacketType, data: [NSData]?)
    private typealias ProbeWaitQueue = [Probe]

    private let allowedCharacterSet = NSCharacterSet(charactersInString: "!*'();:@&=+$,/?%#[]\" {}").invertedSet
    private let emitQueue = dispatch_queue_create("engineEmitQueue", DISPATCH_QUEUE_SERIAL)
    private let handleQueue = dispatch_queue_create("engineHandleQueue", DISPATCH_QUEUE_SERIAL)
    private let logType = "SocketEngine"
    private let parseQueue = dispatch_queue_create("engineParseQueue", DISPATCH_QUEUE_SERIAL)
    private let session: NSURLSession!
    private let workQueue = NSOperationQueue()

    private var closed = false
    private var extraHeaders: [String: String]?
    private var fastUpgrade = false
    private var forcePolling = false
    private var forceWebsockets = false
    private var pingInterval: Double?
    private var pingTimer: NSTimer?
    private var pingTimeout = 0.0 {
        didSet {
            pongsMissedMax = Int(pingTimeout / (pingInterval ?? 25))
        }
    }
    private var pongsMissed = 0
    private var pongsMissedMax = 0
    private var postWait = [String]()
    private var probing = false
    private var probeWait = ProbeWaitQueue()
    private var waitingForPoll = false
    private var waitingForPost = false
    private var websocketConnected = false

    private(set) var connected = false
    private(set) var polling = true
    private(set) var websocket = false

    weak var client: SocketEngineClient?
    var cookies: [NSHTTPCookie]?
    var sid = ""
    var socketPath = ""
    var urlPolling: String?
    var urlWebSocket: String?
    var ws: WebSocket?
    
    @objc public enum PacketType: Int {
        case Open, Close, Ping, Pong, Message, Upgrade, Noop

        init?(str: String) {
            if let value = Int(str), raw = PacketType(rawValue: value) {
                self = raw
            } else {
                return nil
            }
        }
    }

    public init(client: SocketEngineClient, sessionDelegate: NSURLSessionDelegate?) {
        self.client = client
        self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: sessionDelegate, delegateQueue: workQueue)
    }

    public convenience init(client: SocketEngineClient, opts: NSDictionary?) {
        self.init(client: client, sessionDelegate: opts?["sessionDelegate"] as? NSURLSessionDelegate)
        forceWebsockets = opts?["forceWebsockets"] as? Bool ?? false
        forcePolling = opts?["forcePolling"] as? Bool ?? false
        cookies = opts?["cookies"] as? [NSHTTPCookie]
        socketPath = opts?["path"] as? String ?? ""
        extraHeaders = opts?["extraHeaders"] as? [String: String]
    }

    deinit {
        Logger.log("Engine is being deinit", type: logType)
    }

    public func close(fast fast: Bool) {
        Logger.log("Engine is being closed. Fast: %@", type: logType, args: fast)

        pingTimer?.invalidate()
        closed = true

        ws?.disconnect()

        if fast || polling {
            write("", withType: PacketType.Close, withData: nil)
            client?.engineDidClose("Disconnect")
        }

        stopPolling()
    }

    private func createBinaryDataForSend(data: NSData) -> (NSData?, String?) {
        if websocket {
            var byteArray = [UInt8](count: 1, repeatedValue: 0x0)
            byteArray[0] = 4
            let mutData = NSMutableData(bytes: &byteArray, length: 1)

            mutData.appendData(data)

            return (mutData, nil)
        } else {
            var str = "b4"
            str += data.base64EncodedStringWithOptions(
                NSDataBase64EncodingOptions.Encoding64CharacterLineLength)

            return (nil, str)
        }
    }

    private func createURLs(params: [String: AnyObject]?) -> (String?, String?) {
        if client == nil {
            return (nil, nil)
        }

        let path = socketPath == "" ? "/socket.io" : socketPath

        let url = "\(client!.socketURL)\(path)/?transport="
        var urlPolling: String
        var urlWebSocket: String

        if client!.secure {
            urlPolling = "https://" + url + "polling"
            urlWebSocket = "wss://" + url + "websocket"
        } else {
            urlPolling = "http://" + url + "polling"
            urlWebSocket = "ws://" + url + "websocket"
        }

        if params != nil {
            for (key, value) in params! {
                let keyEsc = key.stringByAddingPercentEncodingWithAllowedCharacters(
                    allowedCharacterSet)!
                urlPolling += "&\(keyEsc)="
                urlWebSocket += "&\(keyEsc)="

                if value is String {
                    let valueEsc = (value as! String).stringByAddingPercentEncodingWithAllowedCharacters(
                        allowedCharacterSet)!
                    urlPolling += "\(valueEsc)"
                    urlWebSocket += "\(valueEsc)"
                } else {
                    urlPolling += "\(value)"
                    urlWebSocket += "\(value)"
                }
            }
        }

        return (urlPolling, urlWebSocket)
    }

    private func createWebsocket(andConnect connect: Bool) {
        let wsUrl = urlWebSocket! + (sid == "" ? "" : "&sid=\(sid)")
        
        ws = WebSocket(url: NSURL(string: wsUrl)!,
            cookies: cookies)
        
        if extraHeaders != nil {
            for (headerName, value) in extraHeaders! {
                ws?.headers[headerName] = value
            }
        }
        
        ws?.queue = handleQueue
        ws?.delegate = self

        if connect {
            ws?.connect()
        }
    }

    private func doFastUpgrade() {
        if waitingForPoll {
            Logger.error("Outstanding poll when switched to WebSockets," +
                "we'll probably disconnect soon. You should report this.", type: logType)
        }

        sendWebSocketMessage("", withType: PacketType.Upgrade, datas: nil)
        websocket = true
        polling = false
        fastUpgrade = false
        probing = false
        flushProbeWait()
    }

    private func doPoll() {
        if websocket || waitingForPoll || !connected {
            return
        }

        waitingForPoll = true
        let req = NSMutableURLRequest(URL: NSURL(string: urlPolling! + "&sid=\(sid)&b64=1")!)

        if cookies != nil {
            let headers = NSHTTPCookie.requestHeaderFieldsWithCookies(cookies!)
            req.allHTTPHeaderFields = headers
        }
        
        if extraHeaders != nil {
            for (headerName, value) in extraHeaders! {
                req.setValue(value, forHTTPHeaderField: headerName)
            }
        }
        
        doRequest(req)
    }

    private func doRequest(req: NSMutableURLRequest) {
        if !polling {
            return
        }

        req.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData

        Logger.log("Doing polling request", type: logType)

        session.dataTaskWithRequest(req) {[weak self] data, res, err in
            if let this = self {
                if err != nil || data == nil {
                    if this.polling {
                        this.handlePollingFailed(err?.localizedDescription ?? "Error")
                    } else {
                        Logger.error(err?.localizedDescription ?? "Error", type: this.logType)
                    }
                    return
                }

                Logger.log("Got polling response", type: this.logType)

                if let str = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String {
                    dispatch_async(this.parseQueue) {[weak this] in
                        this?.parsePollingMessage(str)
                    }
                }

                this.waitingForPoll = false

                if this.fastUpgrade {
                    this.doFastUpgrade()
                } else if !this.closed && this.polling {
                    this.doPoll()
                }
            }}.resume()
    }

    private func flushProbeWait() {
        Logger.log("Flushing probe wait", type: logType)

        dispatch_async(emitQueue) {[weak self] in
            if let this = self {
                for waiter in this.probeWait {
                    this.write(waiter.msg, withType: waiter.type, withData: waiter.data)
                }

                this.probeWait.removeAll(keepCapacity: false)

                if this.postWait.count != 0 {
                    this.flushWaitingForPostToWebSocket()
                }
            }
        }
    }

    private func flushWaitingForPost() {
        if postWait.count == 0 || !connected {
            return
        } else if websocket {
            flushWaitingForPostToWebSocket()
            return
        }

        var postStr = ""

        for packet in postWait {
            let len = packet.characters.count

            postStr += "\(len):\(packet)"
        }

        postWait.removeAll(keepCapacity: false)

        let req = NSMutableURLRequest(URL: NSURL(string: urlPolling! + "&sid=\(sid)")!)

        if let cookies = cookies {
            let headers = NSHTTPCookie.requestHeaderFieldsWithCookies(cookies)
            req.allHTTPHeaderFields = headers
        }

        req.HTTPMethod = "POST"
        req.setValue("text/plain; charset=UTF-8", forHTTPHeaderField: "Content-Type")

        let postData = postStr.dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false)!

        req.HTTPBody = postData
        req.setValue(String(postData.length), forHTTPHeaderField: "Content-Length")

        waitingForPost = true

        Logger.log("POSTing: %@", type: logType, args: postStr)

        session.dataTaskWithRequest(req) {[weak self] data, res, err in
            if let this = self {
                if err != nil && this.polling {
                    this.handlePollingFailed(err?.localizedDescription ?? "Error")
                    return
                } else if err != nil {
                    NSLog(err?.localizedDescription ?? "Error")
                    return
                }

                this.waitingForPost = false

                dispatch_async(this.emitQueue) {[weak this] in
                    if !(this?.fastUpgrade ?? true) {
                        this?.flushWaitingForPost()
                        this?.doPoll()
                    }
                }
            }}.resume()
    }

    // We had packets waiting for send when we upgraded
    // Send them raw
    private func flushWaitingForPostToWebSocket() {
        guard let ws = self.ws else {return}
        
        for msg in postWait {
            ws.writeString(msg)
        }

        postWait.removeAll(keepCapacity: true)
    }

    private func handleClose() {
        if let client = client where polling == true {
            client.engineDidClose("Disconnect")
        }
    }

    private func checkIfMessageIsBase64Binary(var message: String) {
        if message.hasPrefix("b4") {
            // binary in base64 string
            message.removeRange(Range<String.Index>(start: message.startIndex,
                end: message.startIndex.advancedBy(2)))

            if let data = NSData(base64EncodedString: message,
                options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
                    client?.parseBinaryData(data)
            }
        }
    }

    private func handleMessage(message: String) {
        client?.parseSocketMessage(message)
    }

    private func handleNOOP() {
        doPoll()
    }

    private func handleOpen(openData: String) {
        let mesData = openData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(mesData,
                options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            if let sid = json?["sid"] as? String {
                let upgradeWs: Bool

                self.sid = sid
                connected = true
                
                if let upgrades = json?["upgrades"] as? [String] {
                    upgradeWs = upgrades.filter {$0 == "websocket"}.count != 0
                } else {
                    upgradeWs = false
                }
                
                if let pingInterval = json?["pingInterval"] as? Double, pingTimeout = json?["pingTimeout"] as? Double {
                    self.pingInterval = pingInterval / 1000.0
                    self.pingTimeout = pingTimeout / 1000.0
                }
                
                if !forcePolling && !forceWebsockets && upgradeWs {
                    createWebsocket(andConnect: true)
                }
            }
        } catch {
            Logger.error("Error parsing open packet", type: logType)
            return
        }

        startPingTimer()

        if !forceWebsockets {
            doPoll()
        }
    }

    private func handlePong(pongMessage: String) {
        pongsMissed = 0

        // We should upgrade
        if pongMessage == "3probe" {
            upgradeTransport()
        }
    }

    // A poll failed, tell the client about it
    private func handlePollingFailed(reason: String) {
        connected = false
        ws?.disconnect()
        pingTimer?.invalidate()
        waitingForPoll = false
        waitingForPost = false

        if !closed {
            client?.didError(reason)
            client?.engineDidClose(reason)
        }
    }

    public func open(opts: [String: AnyObject]? = nil) {
        if connected {
            Logger.error("Tried to open while connected", type: logType)
            client?.didError("Tried to open while connected")
            
            return
        }

        Logger.log("Starting engine", type: logType)
        Logger.log("Handshaking", type: logType)

        closed = false

        (urlPolling, urlWebSocket) = createURLs(opts)

        if forceWebsockets {
            polling = false
            websocket = true
            createWebsocket(andConnect: true)
            return
        }

        let reqPolling = NSMutableURLRequest(URL: NSURL(string: urlPolling! + "&b64=1")!)

        if cookies != nil {
            let headers = NSHTTPCookie.requestHeaderFieldsWithCookies(cookies!)
            reqPolling.allHTTPHeaderFields = headers
        }
 
        if let extraHeaders = extraHeaders {
            for (headerName, value) in extraHeaders {
                reqPolling.setValue(value, forHTTPHeaderField: headerName)
            }
        }
        
        doRequest(reqPolling)
    }

    private func parsePollingMessage(str: String) {
        guard str.characters.count != 1 else {
            return
        }
        
        var reader = SocketStringReader(message: str)
        
        while reader.hasNext {
            let n = reader.readUntilStringOccurence(":")
            let str = reader.read(Int(n)!)
            
            dispatch_async(handleQueue) {
                self.parseEngineMessage(str, fromPolling: true)
            }
        }
    }

    private func parseEngineData(data: NSData) {
        Logger.log("Got binary data: %@", type: "SocketEngine", args: data)
        client?.parseBinaryData(data.subdataWithRange(NSMakeRange(1, data.length - 1)))
    }

    private func parseEngineMessage(var message: String, fromPolling: Bool) {
        Logger.log("Got message: %@", type: logType, args: message)

        if fromPolling {
            fixDoubleUTF8(&message)
        }

        let type = PacketType(str: (message["^(\\d)"].groups()?[1]) ?? "") ?? {
            self.checkIfMessageIsBase64Binary(message)
            return .Noop
            }()

        switch type {
        case PacketType.Message:
            message.removeAtIndex(message.startIndex)
            handleMessage(message)
        case PacketType.Noop:
            handleNOOP()
        case PacketType.Pong:
            handlePong(message)
        case PacketType.Open:
            message.removeAtIndex(message.startIndex)
            handleOpen(message)
        case PacketType.Close:
            handleClose()
        default:
            Logger.log("Got unknown packet type", type: logType)
        }
    }

    private func probeWebSocket() {
        if websocketConnected {
            sendWebSocketMessage("probe", withType: PacketType.Ping)
        }
    }

    /// Send an engine message (4)
    public func send(msg: String, withData datas: [NSData]?) {
        if probing {
            probeWait.append((msg, PacketType.Message, datas))
        } else {
            write(msg, withType: PacketType.Message, withData: datas)
        }
    }

    @objc private func sendPing() {
        //Server is not responding
        if pongsMissed > pongsMissedMax {
            pingTimer?.invalidate()
            client?.engineDidClose("Ping timeout")
            return
        }

        ++pongsMissed
        write("", withType: PacketType.Ping, withData: nil)
    }

    /// Send polling message.
    /// Only call on emitQueue
    private func sendPollMessage(var msg: String, withType type: PacketType,
        datas:[NSData]? = nil) {
            Logger.log("Sending poll: %@ as type: %@", type: logType, args: msg, type.rawValue)

            doubleEncodeUTF8(&msg)
            let strMsg = "\(type.rawValue)\(msg)"

            postWait.append(strMsg)

            for data in datas ?? [] {
                let (_, b64Data) = createBinaryDataForSend(data)

                postWait.append(b64Data!)
            }

            if !waitingForPost {
                flushWaitingForPost()
            }
    }

    /// Send message on WebSockets
    /// Only call on emitQueue
    private func sendWebSocketMessage(str: String, withType type: PacketType,
        datas:[NSData]? = nil) {
            Logger.log("Sending ws: %@ as type: %@", type: logType, args: str, type.rawValue)

            ws?.writeString("\(type.rawValue)\(str)")

            for data in datas ?? [] {
                let (data, _) = createBinaryDataForSend(data)
                if data != nil {
                    ws?.writeData(data!)
                }
            }
    }

    // Starts the ping timer
    private func startPingTimer() {
        if let pingInterval = pingInterval {
            pingTimer?.invalidate()
            pingTimer = nil

            dispatch_async(dispatch_get_main_queue()) {
                self.pingTimer = NSTimer.scheduledTimerWithTimeInterval(pingInterval, target: self,
                    selector: Selector("sendPing"), userInfo: nil, repeats: true)
            }
        }
    }

    func stopPolling() {
        session.invalidateAndCancel()
    }

    private func upgradeTransport() {
        if websocketConnected {
            Logger.log("Upgrading transport to WebSockets", type: logType)

            fastUpgrade = true
            sendPollMessage("", withType: PacketType.Noop)
            // After this point, we should not send anymore polling messages
        }
    }

    /**
    Write a message, independent of transport.
    */
    public func write(msg: String, withType type: PacketType, withData data: [NSData]?) {
        dispatch_async(emitQueue) {
            if self.connected {
                if self.websocket {
                    Logger.log("Writing ws: %@ has data: %@", type: self.logType, args: msg,
                        data == nil ? false : true)
                    self.sendWebSocketMessage(msg, withType: type, datas: data)
                } else {
                    Logger.log("Writing poll: %@ has data: %@", type: self.logType, args: msg,
                        data == nil ? false : true)
                    self.sendPollMessage(msg, withType: type, datas: data)
                }
            }
        }
    }

    // Delagate methods

    public func websocketDidConnect(socket:WebSocket) {
        websocketConnected = true

        if !forceWebsockets {
            probing = true
            probeWebSocket()
        } else {
            connected = true
            probing = false
            polling = false
        }
    }

    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        websocketConnected = false
        probing = false

        if closed {
            client?.engineDidClose("Disconnect")
            return
        }

        if websocket {
            pingTimer?.invalidate()
            connected = false
            websocket = false

            let reason = error?.localizedDescription ?? "Socket Disconnected"

            if error != nil {
                client?.didError(reason)
            }
            
            client?.engineDidClose(reason)
        } else {
            flushProbeWait()
        }
    }

    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        parseEngineMessage(text, fromPolling: false)
    }

    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        parseEngineData(data)
    }
}
