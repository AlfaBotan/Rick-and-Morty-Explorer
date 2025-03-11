//
//  CharacterTransitionAnimator.swift
//  Rick and Morty Explorer
//
//  Created by Илья Волощик on 12.03.25.
//

import UIKit

class CharacterTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.5
    var isPresenting = true
    var selectedCellFrame: CGRect = .zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
        else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView

        if isPresenting {

            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0

            let imageView = UIImageView(frame: selectedCellFrame)
            imageView.image = UIImage(named: "placeholder")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            containerView.addSubview(imageView)

            UIView.animate(withDuration: duration, animations: {
                imageView.frame = CGRect(x: 0, y: 0, width: toViewController.view.frame.width, height: 300)
                toViewController.view.alpha = 1
            }, completion: { _ in
                imageView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        } else {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

            UIView.animate(withDuration: duration, animations: {
                fromViewController.view.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}
