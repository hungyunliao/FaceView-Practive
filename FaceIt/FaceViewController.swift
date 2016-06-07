//
//  ViewController.swift
//  FaceIt
//
//  Created by Hung-Yun Liao on 5/27/16.
//  Copyright © 2016 Hung-Yun Liao. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    // MARK: Model
    // in the controller, declare a model to take the control of it
    // a pointer to the model
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smirk) {
        didSet { // everytime the model get modified, didset will get called
            updateUI()
        }
    } // expression changes only when the UI is modified at LATER times (when the model is changed), NOT at initial phase
    
    
    // MARK: Controller
    // a pointer to the faceview, so now we can talk to the VIEW
    // didSet will be called only once when the "faceView" outlet is hooked up with the real "faceView" view.
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            // only VIEW could recognize the gestures.
            // pinch is changing only the VIEW, not the model, so the target is a VIEW
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(FaceView.changeScale(_:))
            )) // selector: handler
            
            // Swiping will modify the model, so the target will be controller itself
            // increaseHappiness takes no argument.
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            // configure the swipe gesture
            happierSwipeGestureRecognizer.direction = .Up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            sadderSwipeGestureRecognizer.direction = .Down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            
            updateUI()
        }
    }
    
    
    // viewcontroller's function that modifies the model "expression"
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    // do not need to add "addGestureRecognizer" call in the faceView separately. It is automatically added the call
    @IBAction func toggleEyes(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            switch expression.eyes {
            case .Closed: expression.eyes = .Open
            case .Open: expression.eyes = .Closed
            case .Squinting: break
            }
        }
    }
    
    private var mouthCurvature = [
        FacialExpression.Mouth.Frown: -1.0,
        .Grin: 0.5,
        .Smile: 1.0,
        .Smirk: -0.5,
        .Neutrual: 0.0
    ]
    
    private var eyeBrowTilts = [
        FacialExpression.EyeBrows.Furrowed: -0.5,
        .Normal: 0.0,
        .Relaxed: 0.5
    ]
    
    private func updateUI() {
        if faceView != nil { // will be runtime error if it is not set, because the segues prepartion will be called BEFORE the outlet is hooked up, and the faceView is nil.
            switch expression.eyes {
            case .Open: faceView.eyeOpen = true
            case .Closed: faceView.eyeOpen = false
            case .Squinting: faceView.eyeOpen = false
            }
            
            faceView.mouthCurvature = mouthCurvature[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
}

