//
//  DKPhotoGalleryTransitionDismiss.swift
//  DKPhotoGallery
//
//  Created by ZhangAo on 16/6/22.
//  Copyright © 2016年 ZhangAo. All rights reserved.
//

import UIKit

@objc
open class DKPhotoGalleryTransitionDismiss: NSObject, UIViewControllerAnimatedTransitioning {
    
    var gallery: DKPhotoGallery!
    
    // UIViewControllerAnimatedTransitioning
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        let containerView = transitionContext.containerView
        let fromContentView = self.gallery.currentContentView()
        
        self.gallery.setNavigationBarHidden(true, animated: true)
        
        if let toImageView = self.gallery.dismissImageViewBlock?(self.gallery.contentVC.currentIndex), let _ = toImageView.image {
            fromContentView.clipsToBounds = true
            toImageView.isHidden = true
            UIView.animate(withDuration: transitionDuration, animations: {
                let toImageViewFrameInScreen = toImageView.superview!.convert(toImageView.frame, to: nil)
                fromContentView.frame = toImageViewFrameInScreen
                fromContentView.contentMode = toImageView.contentMode
                fromContentView.backgroundColor = toImageView.backgroundColor
                self.gallery.updateContextBackground(alpha: 0, animated: false)
            }) { (finished) in
                toImageView.isHidden = false
                
                let wasCanceled = transitionContext.transitionWasCancelled
                if wasCanceled {
                    self.gallery.updateContextBackground(alpha: 1, animated: false)
                }
                
                transitionContext.completeTransition(!wasCanceled)
            }
        } else {
            UIView.animate(withDuration: transitionDuration, animations: { 
                containerView.alpha = 0
                fromContentView.alpha = 0
                self.gallery.updateContextBackground(alpha: 0, animated: false)
            }, completion: { (finished) in
                let wasCanceled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!wasCanceled)
            })
        }
    }
    
}
