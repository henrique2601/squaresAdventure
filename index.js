var app = require('http').createServer()

app.listen(3001)

function Player(socket) {
    var self = this
    this.socket = socket
    this.name = ""
    this.game = {}
    this.room = ""
    this.id = 9999999

    this.socket.on("u", function(room, x, y , vx , vy , rotation , vrotation) {
        self.game.update( self.socket ,self.id , room , x, y , vx , vy , rotation , vrotation)
    })

    this.socket.on("win", function(room) {
        self.game.win( self.socket ,self.id , room )
    })

    this.socket.on("r", function(name,room) {
        self.joinRoom(name,room)
    })


    this.socket.on('disconnect', function(){
            console.log( self.name + " disconnect" )
            var idx = self.game.rooms[self.room].indexOf(self.name)
            self.game.rooms[self.room].splice(idx, 1)
    });
    
}



Player.prototype.joinRoom = function(name,room) {
    this.name = name
    this.room = room
    this.socket.join(this.room)

    if (this.game.rooms[this.room] === undefined) {
        this.game.rooms[this.room] = new Array()
        this.id = 0
    } else {
        this.id = this.game.rooms[this.room].length
    }
    
    var teste = {name : this.name , id : this.id}

    console.log(this.game.rooms[this.room])
    
    this.socket.emit("a", this.game.rooms[this.room])
    this.socket.broadcast.to(this.room).emit("j" , teste)

    this.game.rooms[this.room].push(teste)

    
 
}





function Game() {
    this.io = require('socket.io')(app)
 
    this.players = []
    this.rooms = []

    console.log(this.players.length)

    this.started = false
    this.addHandlers()
}

Game.prototype.addHandlers = function() {
    var game = this

    this.io.sockets.on("connection", function(socket) {
        game.addPlayer(new Player(socket))
        socket.emit("d")

        

        

    })
}

Game.prototype.addPlayer = function(player) {
    
    
    player.game = this
    

}



Game.prototype.update = function(socket, id, room, x, y , vx , vy , rotation , vrotation) {

    
        socket.broadcast.to(room).emit("u", id , x, y , vx , vy , rotation , vrotation )
    
    

}


Game.prototype.win = function(socket, id, room) {

    
        socket.broadcast.to(room).emit("win", id)
    
    

}



Game.prototype.startGame = function() {
    this.player1.socket.emit("startGame")
    this.player2.socket.emit("startGame")
}


var game = new Game()