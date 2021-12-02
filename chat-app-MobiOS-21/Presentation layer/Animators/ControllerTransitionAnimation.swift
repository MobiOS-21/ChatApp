//
//  AnimationControllerTransition.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 02.12.2021.
//

import Foundation

enum AnimationType {
    case present
    case dismiss
}

class ControllerTransitionAnimation: NSObject {
    private let animationDuration: Double
    private let animationType: AnimationType

    // MARK: - Init
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}

extension ControllerTransitionAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
                  transitionContext.completeTransition(false)
                  return
              }
        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
        case .dismiss:
            transitionContext.containerView.addSubview(toViewController.view)
            transitionContext.containerView.addSubview(fromViewController.view)
            dismissAnimation(with: transitionContext, viewToAnimate: fromViewController.view)
        }
    }
    
    private func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        viewToAnimate.clipsToBounds = true
        viewToAnimate.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut) {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    private func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        let duration = transitionDuration(using: transitionContext)
        let scaleDown = CGAffineTransform(scaleX: 0.3, y: 0.3)
        let moveOut = CGAffineTransform(translationX: -viewToAnimate.frame.width, y: 0)
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7) {
                viewToAnimate.transform = scaleDown
            }
            
            UIView.addKeyframe(withRelativeStartTime: 3 / duration, relativeDuration: 1) {
                viewToAnimate.transform = scaleDown.concatenating(moveOut)
                viewToAnimate.alpha = 0
            }
        }, completion: { _ in
            viewToAnimate.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
