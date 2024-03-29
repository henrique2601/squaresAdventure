//
//  Textfield.swift
//  TowerUp
//
//  Created by Paulo Henrique dos Santos on 03/09/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Textfield: Control {
    
static var textfieldList = Set<Textfield>()
    var myTextField: UITextField!
    
    
    init(name:String, x:Int, y:Int, view:UIView) {
        super.init()
        self.load(name: name, textureName: name, x: x, y: y, xAlign: .left, yAlign: .up, view:view)
    }

    init(name:String, textureName:String, x:Int, y:Int, view:UIView) {
        super.init()
        self.load(name: name, textureName: textureName, x: x, y: y, xAlign: .left, yAlign: .up, view:view)
    }
    
    init(name:String, x:Int, y:Int, align:Control.xAlignments, view:UIView) {
        super.init()
        self.load(name: name, textureName: name, x: x, y: y, xAlign: align, yAlign: .center, view:view)
    }
    
    init(name:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, view:UIView) {
        super.init()
        self.load(name: name, textureName: name, x: x, y: y, xAlign: xAlign, yAlign: yAlign, view:view)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, align:Control.xAlignments, view:UIView) {
        super.init()
        self.load(name: name, textureName: textureName, x: x, y: y, xAlign: align, yAlign: .center, view:view)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, view:UIView) {
        super.init()
        self.load(name: name, textureName: textureName, x: x, y: y, xAlign: xAlign, yAlign: yAlign, view:view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, view:UIView) {
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition/2
        
        self.myTextField = UITextField(frame: CGRect(x: 0, y: 0 , width: 150, height: 50))
        view.addSubview(myTextField)
        self.myTextField.backgroundColor = GameColors.white
        self.myTextField.text = name
        self.myTextField.borderStyle = UITextField.BorderStyle.roundedRect
        self.myTextField.textAlignment = NSTextAlignment.center
        
        Textfield.textfieldList.insert(self)
    }
    
    class func resetTextfields() {
        for textfield in Textfield.textfieldList {
            textfield.resetPosition()
        }
    }
    
    override func resetPosition() {
        super.resetPosition()
        
        let sceneSize:CGSize = CGSize(width: 1334/2, height: 750/2)
        
        let xScale = Config.skViewBoundsSize.width / sceneSize.width
        //let yScale = Config.skViewBoundsSize.height / sceneSize.height
        
        let y0 = (self.sketchPosition.y / 2 ) * xScale
        
        self.myTextField?.frame = CGRect.init(x:self.position.x * xScale, y: y0 + Config.translateInView.y, width: 150 * xScale, height: 40 * xScale)
        self.myTextField?.font = UIFont (name: "TrebuchetMS", size: 22 * xScale)
        
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        self.myTextField.removeFromSuperview()
    }

}
