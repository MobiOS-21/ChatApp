//
//  Animators.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 01.12.2021.
//

import Foundation
import UIKit

protocol AnimatorsProtocol {
    func buttonShakeAnimation(duration: TimeInterval) -> CAAnimationGroup
    func getEmmitter(with image: UIImage) -> CAEmitterLayer
    func controllerTransitionAnimation(animationDuration: Double, animationType: AnimationType) -> UIViewControllerAnimatedTransitioning
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
    
    func getEmmitter(with image: UIImage) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .circle
        emitter.emitterCells = generateEmitterCells(with: image)
        return emitter
    }
    
    private func generateEmitterCells(with image: UIImage) -> [CAEmitterCell] {
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.birthRate = 5
        cell.lifetime = 2
        cell.lifetimeRange = 1
        cell.scale = 0.08
        cell.emissionRange = 360 * .pi / 180
        cell.velocity = 10
        cell.velocityRange = 10
        cell.alphaSpeed = -0.3
        cell.spin = 45 * .pi / 180
        return [cell]
    }
    
    func controllerTransitionAnimation(animationDuration: Double, animationType: AnimationType) -> UIViewControllerAnimatedTransitioning {
        ControllerTransitionAnimation(animationDuration: animationDuration, animationType: animationType)
    }
}
