//
//  Animators.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 01.12.2021.
//

import Foundation

protocol AnimatorsProtocol {
    func buttonShakeAnimation(duration: TimeInterval) -> CAAnimationGroup
}

class Animators: AnimatorsProtocol {
    func buttonShakeAnimation(duration: TimeInterval) -> CAAnimationGroup {
        let translationX = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translationX.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translationX.values = [-5, 5, -5]
        
        let translationY = CAKeyframeAnimation(keyPath: "transform.translation.y")
        translationY.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translationY.values = [-5, 5, -5]
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [18, -18, 18].map { (degrees: Double) -> Double in
            let radians: Double = (.pi * degrees) / 180.0
            return radians
        }
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [rotation]
        shakeGroup.repeatCount = .infinity
        shakeGroup.duration = duration
        return shakeGroup
    }
}
