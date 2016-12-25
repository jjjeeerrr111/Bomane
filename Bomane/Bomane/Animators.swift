//
//  Animators.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-12-17.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

class SlideAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.5
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //1. setup the transition
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView
        let toVC = transitionContext.viewController(forKey: .to)!
        let toView = toVC.view!
        let fromView = transitionContext.view(forKey: .from) ?? transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view
        
        
        
        
        //2. animations
        // set up from 2D transforms that we'll use in the animation
        let offScreenRight = CGAffineTransform(translationX: 0, y: -container.frame.height)
        let offScreenLeft = CGAffineTransform(translationX: 0, y: 0)
        
        
        
        // start the toView to the right of the screen
        if self.presenting {
            //Add the to view to the container view, by default the from View is already in it.
            //Only add if its presenting, since if you are dismissing. it already exists
            container.addSubview(toView)
            toView.transform = offScreenRight
        } else {
            fromView!.transform = offScreenLeft
            toView.transform = offScreenLeft
        }
        
        
        // perform the animation!
        // for this example, just slide both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: [], animations: {
            
            if self.presenting {
                toView.transform = CGAffineTransform.identity
            } else {
                fromView!.transform = offScreenRight
                toView.transform = CGAffineTransform.identity
            }
            
            
            
        }, completion: { finished in
            
            // tell our transitionContext object that we've finished animating
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        })
        
    }
    
}

class DimissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.2
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //1. setup the transition
        //let container = transitionContext.containerView
        
        if let toView = transitionContext.view(forKey: .to) ?? transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view {
            //container.addSubview(toView)
            UIView.animate(withDuration: duration, animations: {
                toView.transform = CGAffineTransform.identity
            }, completion: {_ in
                //transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        
        
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        
        
    }
}

class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.1
    var originFram = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //1. setup the transition
        let container = transitionContext.containerView
        
        if let toVC = transitionContext.viewController(forKey: .to) as? TimeSelectionViewController {
            if let fromView = transitionContext.view(forKey: .from) ?? transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view {
                UIView.animate(withDuration: 0.2, animations: {
                    fromView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                }, completion: nil)
                
            }
            
            let toView = toVC.view!
            //toView.alpha = 0
            
            
            container.addSubview(toView)
            
            //2. animations
            toVC.animateBackground(presented:true)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        } else if let toVC = transitionContext.viewController(forKey: .to) as? StylistSelectionViewController {
            if let fromView = transitionContext.view(forKey: .from) ?? transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view {
                UIView.animate(withDuration: 0.2, animations: {
                    fromView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                }, completion: nil)
                
            }
            
            let toView = toVC.view!
            //toView.alpha = 0
            
            
            container.addSubview(toView)
            
            //2. animations
            toVC.animateBackground(presented:true)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        } else if let toVC = transitionContext.viewController(forKey: .to) as? ServiceSelectionViewController {
            if let fromView = transitionContext.view(forKey: .from) ?? transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view {
                UIView.animate(withDuration: 0.2, animations: {
                    fromView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                }, completion: nil)
                
            }
            
            let toView = toVC.view!
            //toView.alpha = 0
            
            
            container.addSubview(toView)
            
            //2. animations
            toVC.animateBackground(presented:true)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        
        
    }
    
}

