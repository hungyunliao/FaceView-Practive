//
//  ViewController.swift
//  FaceIt
//
//  Created by Hung-Yun Liao on 5/27/16.
//  Copyright © 2016 Hung-Yun Liao. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile) { // a pointer to the model
        didSet {
            updateUI()
        }
    } // expression changes only when the UI is modified at LATER times (when the model is changed), NOT at initial phase
    
    @IBOutlet weak var faceView: FaceView! { didSet { updateUI() } }// a pointer to the faceview, so now we can talk to the face
    // didSet will be called when the FaceView is set. Will update when initialized
    
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
        switch expression.eyes {
        case .Open: faceView.eyeOpen = true
        case .Closed: faceView.eyeOpen = false
        case .Squinting: faceView.eyeOpen = false
        }
        
        faceView.mouthCurvature = mouthCurvature[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
    }
}

