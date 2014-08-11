//
//  DetailViewController.swift
//  TestTransition
//
//  Created by ZhangAo on 14-8-8.
//
//
enum ModalPresentingType {
    case Present, Dismiss
}

import UIKit

class DetailViewController: UIViewController ,UIViewControllerTransitioningDelegate ,UIViewControllerAnimatedTransitioning {
    var modalPresentingType: ModalPresentingType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        println("DetailVC deinit")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let modal = segue.destinationViewController as UIViewController
        modal.transitioningDelegate = self
    }
    
    //UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        modalPresentingType = ModalPresentingType.Present
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        modalPresentingType = ModalPresentingType.Dismiss
        return self
    }
    
    //UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        let containerView = transitionContext.containerView()
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        var destView: UIView!
        var destTransfrom = CGAffineTransformIdentity
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        if modalPresentingType == ModalPresentingType.Present {
            destView = toViewController.view
            destView.transform = CGAffineTransformMakeTranslation(0, screenHeight)
            containerView.addSubview(toViewController.view)
        } else if modalPresentingType == ModalPresentingType.Dismiss {
            destView = fromViewController.view
            destTransfrom = CGAffineTransformMakeTranslation(0, screenHeight)
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0,
        options: UIViewAnimationOptions.CurveLinear, animations: {
            destView.transform = destTransfrom
        }, completion: {completed in
            transitionContext.completeTransition(true)
        })
    }
}
