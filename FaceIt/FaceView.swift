//
//  FaceView.swift
//  FaceIt
//
//  Created by Hung-Yun Liao on 5/27/16.
//  Copyright © 2016 Hung-Yun Liao. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    /* Public instances */
    // make them var is to let user change them from their codes.
    var scale: CGFloat =  0.9
    var mouthCurvature: CGFloat = 1.0 // between -1.0(sad face) to 1.0(happy face)
    
    
    /* Private instances */
    private var width: CGFloat { // has to do in this way because now is in the "initialization phase", so you cannot assign width to a "bounds" which is a class property but the class has not been initialized yet.
        return bounds.size.width
    }
    private var height: CGFloat {
        //get {  // if the var has only "get" property, you can avoid typing "get {}"
            return bounds.size.height
        //}
    }
    
    private var skullRadius: CGFloat {
        return min(width, height) / 2 * scale
    }
    
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    // also works: var skullCenter = convertPoint(center, fromView: superview)
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeigth: CGFloat = 3
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter: CGPoint = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    
    private func pathForEye(eye: Eye) -> UIBezierPath {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCeter = getEyeCenter(eye)
        
        return pathForCircleCenteredAtPoint(eyeCeter, withRadius: eyeRadius)
    }
    
    private func pathForMouth() -> UIBezierPath {
        
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeigth
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(min(1, max(-1, mouthCurvature))) * mouthHeight
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let ctrlPoint1 = CGPoint(x: mouthRect.minX + mouthWidth/3, y: mouthRect.minY + smileOffset)
        let ctrlPoint2 = CGPoint(x: mouthRect.maxX - mouthWidth/3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: ctrlPoint1, controlPoint2: ctrlPoint2)
        path.lineWidth = 5.0
        return path
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false
        )
        path.lineWidth = 5.0
        return path
    }
    
    override func drawRect(rect: CGRect) {
        
        UIColor.blueColor().set() // set(): set both stroke and fill
        
        pathForCircleCenteredAtPoint(skullCenter, withRadius: skullRadius).stroke()
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
        pathForMouth().stroke()
        
    }

}
