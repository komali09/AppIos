//
//  ImageShrinkAnimationController.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/24/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit

protocol ImageShrinkAnimationControllerProtocol {
    func getInitialImageFrame() -> CGRect
}

class ImageShrinkAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var destinationFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            fromVC is ImageShrinkAnimationControllerProtocol,
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.white
        containerView.addSubview(toVC.view)
        
        // setup cell image snapshot
        let initialFrame = (fromVC as! ImageShrinkAnimationControllerProtocol).getInitialImageFrame()
        let finalFrame = destinationFrame
        let snapshot = fromVC.view.resizableSnapshotView(from: initialFrame, afterScreenUpdates: false, withCapInsets: .zero)!
        snapshot.frame = initialFrame
        containerView.addSubview(snapshot)
    
        
        // setup snapshot to the bottom of selected cell image
        let bottomFinalFrameY = finalFrame.origin.y + finalFrame.height
        let bottomFinalFrame = CGRect(x: 0, y: bottomFinalFrameY, width: screenWidth, height: screenHeight)
        let bottomInitialFrame = CGRect(x: 0, y: bottomFinalFrame.height, width: screenWidth, height: screenHeight)
        let bottomSnapshot = toVC.view.resizableSnapshotView(from: bottomFinalFrame, afterScreenUpdates: false, withCapInsets: .zero)!
        bottomSnapshot.frame = bottomInitialFrame
        
        containerView.addSubview(bottomSnapshot)
        
        // setup snapshot to the top of selected cell image
        let topFinalFrame = CGRect(x: 0, y: finalFrame.origin.y - screenHeight, width: screenWidth, height: screenHeight)
        let topInitialFrame = CGRect(x: 0, y: -topFinalFrame.height, width: topFinalFrame.width, height: topFinalFrame.height)
        let topSnapshot = toVC.view.resizableSnapshotView(from: topFinalFrame, afterScreenUpdates: false, withCapInsets: .zero)!
        topSnapshot.frame = topInitialFrame
        
        containerView.addSubview(topSnapshot)
        
        
        // setup the bottom component of the origin view
        let fromVCBottomInitialFrameY = initialFrame.origin.y + initialFrame.height
        let fromVCBottomInitialFrame = CGRect(x: 0, y: fromVCBottomInitialFrameY, width: screenWidth, height: screenHeight - fromVCBottomInitialFrameY)
        let fromVCBottomFinalFrame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: fromVCBottomInitialFrame.height)
        let fromVCSnapshot = fromVC.view.resizableSnapshotView(from: fromVCBottomInitialFrame, afterScreenUpdates: false, withCapInsets: .zero)!
        fromVCSnapshot.frame = fromVCBottomInitialFrame
        
        containerView.addSubview(fromVCSnapshot)
        
        toVC.view.isHidden = true
        fromVC.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: 0.3, animations: {
            fromVCSnapshot.frame = fromVCBottomFinalFrame
            
        }, completion: { _ in
            fromVCSnapshot.removeFromSuperview()
        })
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
            
            snapshot.frame = finalFrame
            bottomSnapshot.frame = bottomFinalFrame
            topSnapshot.frame = topFinalFrame
            
        }, completion: { _ in
            
            toVC.view.isHidden = false
            fromVC.view.isHidden = false
            
            snapshot.removeFromSuperview()
            bottomSnapshot.removeFromSuperview()
            topSnapshot.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

