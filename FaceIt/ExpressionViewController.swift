//
//  ExpressionViewController.swift
//  FaceIt
//
//  Created by Hung-Yun Liao on 6/7/16.
//  Copyright © 2016 Hung-Yun Liao. All rights reserved.
//

import UIKit

class ExpressionViewController: UIViewController {
    
    private var emotionalFaces: Dictionary<String, FacialExpression> = [  // input a String, output a initializer for the class (type) "FacialExpression"
        "angry" : FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
        "happy" : FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "worried" : FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
        "mischievious" : FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)
    ]
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController { // when segue to a navigationcontroller, it will look inside
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let facevc = destinationvc as? FaceViewController {
            if let identifier = segue.identifier { // identifier might return nil if the programmer forgot to set "identifier" when create a segue
                if let expression = emotionalFaces[identifier] { // the identifier might not exsists in the dictionary
                    facevc.expression = expression
                    if let sendingButton = sender as? UIButton {
                        facevc.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
    }
    

}
