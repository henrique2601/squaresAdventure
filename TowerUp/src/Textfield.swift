//
//  Textfield.swift
//  TowerUp
//
//  Created by Paulo Henrique dos Santos on 03/09/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Textfield: Control, UITextFieldDelegate {
    
static var textfieldList = Set<Textfield>()
    var myTextField: UITextField!
    
    init(name:String, x:Int, y:Int, view:UIView) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: .left, yAlign: .up, view:view)
    }

    init(name:String, textureName:String, x:Int, y:Int, view:UIView) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: .left, yAlign: .up, view:view)
    }
    
    init(name:String, x:Int, y:Int, align:Control.xAlignments, view:UIView) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: align, yAlign: .center, view:view)
    }
    
    init(name:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, view:UIView) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: xAlign, yAlign: yAlign, view:view)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, align:Control.xAlignments, view:UIView) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: align, yAlign: .center, view:view)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, view:UIView) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: xAlign, yAlign: yAlign, view:view)
    }
    
    init(name:String, color:UIColor, x:Int, y:Int, view:UIView) {
        super.init()
        self.load(name, color:color, textureName: name, x: x, y: y, xAlign: .left, yAlign: .up, view:view)
    }
    
    init(name:String, color:UIColor, textureName:String, x:Int, y:Int, view:UIView) {
        super.init()
        self.load(name, color:color, textureName: textureName, x: x, y: y, xAlign: .left, yAlign: .up, view:view)
    }
    
    init(name:String, color:UIColor, x:Int, y:Int, align:Control.xAlignments, view:UIView) {
        super.init()
        self.load(name, color:color, textureName: name, x: x, y: y, xAlign: align, yAlign: .center, view:view)
    }
    
    init(name:String, color:UIColor, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, view:UIView) {
        super.init()
        self.load(name, color:color, textureName: name, x: x, y: y, xAlign: xAlign, yAlign: yAlign, view:view)
    }
    
    init(name:String, color:UIColor, textureName:String, x:Int, y:Int, align:Control.xAlignments, view:UIView) {
        super.init()
        self.load(name, color:color, textureName: textureName, x: x, y: y, xAlign: align, yAlign: .center, view:view)
    }
    
    init(name:String, color:UIColor, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, view:UIView) {
        super.init()
        self.load(name, color:color, textureName: textureName, x: x, y: y, xAlign: xAlign, yAlign: yAlign, view:view)
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
        self.myTextField.delegate = self
        self.myTextField.backgroundColor = GameColors.white
        self.myTextField.text = name
        self.myTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.myTextField.textAlignment = NSTextAlignment.Center
        
        
        
        Textfield.textfieldList.insert(self)
    }
    
    func load(name:String, color:UIColor, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, view:UIView) {
        fatalError("ainda nao implementado")
//        self.name = name
//        self.sketchPosition = CGPoint(x: x, y: y)
//        self.yAlign = yAlign
//        self.xAlign = xAlign
//        self.zPosition = Config.HUDZPosition/2
//        
//        let labelNode = SKLabelNode(fontNamed: "Trebuchet MS")
//        labelNode.text = textureName
//        labelNode.fontSize = 25/2
//        labelNode.fontColor = color
//        labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
//        labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
//        
//        labelNode.name = name
//        self.addChild(labelNode)
//        
//        Control.controlList.insert(self)
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
        
        
        self.myTextField?.frame = CGRectMake(self.position.x * xScale, y0 + Config.translateInView.y, 150 * xScale, 40 * xScale)
        self.myTextField?.font = UIFont (name: "TrebuchetMS", size: 22 * xScale)
        
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        self.myTextField.removeFromSuperview()
    }

}