//
//  ViewController.swift
//  TestTransition
//
//  Created by ZhangAo on 14-8-8.
//
//

import UIKit

class ViewController: UIViewController ,UINavigationControllerDelegate ,UIViewControllerAnimatedTransitioning
/*,UIViewControllerInteractiveTransitioning*/ {
    var navigationOperation: UINavigationControllerOperation?
    var selectedIndex = 0
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        self.navigationController!.view.backgroundColor = UIColor.whiteColor()
        
        let popRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("handlePopRecognizer:"))
        popRecognizer.edges = UIRectEdge.Left
        self.navigationController!.view.addGestureRecognizer(popRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let detailVC = segue.destinationViewController as! DetailViewController
        detailVC.detailImage = sender?.imageForState(UIControlState.Normal)
        selectedIndex = sender.tag
    }
    
    func handlePopRecognizer(popRecognizer: UIScreenEdgePanGestureRecognizer) {
        var progress = popRecognizer.translationInView(navigationController!.view).x / navigationController!.view.bounds.size.width
        progress = min(1.0, max(0.0, progress))
        
        print("\(progress)")
        if popRecognizer.state == UIGestureRecognizerState.Began {
            print("Began")
            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController!.popViewControllerAnimated(true)
        } else if popRecognizer.state == UIGestureRecognizerState.Changed {
            self.interactivePopTransition!.updateInteractiveTransition(progress)
//            updateWithPercent(progress)
            print("Changed")
        } else if popRecognizer.state == UIGestureRecognizerState.Ended || popRecognizer.state == UIGestureRecognizerState.Cancelled {
            if progress > 0.5 {
                self.interactivePopTransition!.finishInteractiveTransition()
            } else {
                self.interactivePopTransition!.cancelInteractiveTransition()
            }
//            finishBy(progress < 0.5)
            print("Ended || Cancelled")
            self.interactivePopTransition = nil
        }
    }
    
    //UIViewControllerInteractiveTransitioning
//    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning!) {
//        self.transitionContext = transitionContext
//        
//        let containerView = transitionContext.containerView()
//        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
//        
//        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
//        
//        self.transitingView = fromViewController.view
//        self.transitingDestView = toViewController.view
//    }
//    
//    func updateWithPercent(percent: CGFloat) {
//        let scale = CGFloat(fabsf(Float(percent - CGFloat(1.0))))
//        transitingView?.transform = CGAffineTransformMakeScale(scale, scale)
//        transitionContext?.updateInteractiveTransition(percent)
//        self.transitingDestView?.alpha = percent
//    }
//    
//    func finishBy(cancelled: Bool) {
//        if cancelled {
//            UIView.animateWithDuration(0.4, animations: {
//                self.transitingView!.transform = CGAffineTransformIdentity
//                self.transitingDestView?.alpha = 0
//            }, completion: {completed in
//                self.transitionContext!.cancelInteractiveTransition()
//                self.transitionContext!.completeTransition(false)
//            })
//        } else {
//            UIView.animateWithDuration(0.4, animations: {
//                print(self.transitingView)
//                self.transitingView!.transform = CGAffineTransformMakeScale(0, 0)
//                self.transitingDestView?.alpha = 1
//                print(self.transitingView)
//            }, completion: {completed in
//                self.transitionContext!.finishInteractiveTransition()
//                self.transitionContext!.completeTransition(true)
//            })
//        }
//    }

    // UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if operation == UINavigationControllerOperation.Push {
            navigationOperation = operation
            return self
            
//        }
//        return nil
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if self.interactivePopTransition == nil {
            return nil
        }
        return self.interactivePopTransition
    }
    
    //UIViewControllerTransitioningDelegate
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!

        var detailVC: DetailViewController!
        var fromView: UIView!
        var alpha: CGFloat = 1.0
        var destTransform: CGAffineTransform!
        
        var snapshotImageView: UIView!
        //获取到当前选择的Button
        let originalView = self.view.viewWithTag(selectedIndex)
        
        if navigationOperation == UINavigationControllerOperation.Push {
            containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
            snapshotImageView = originalView?.snapshotViewAfterScreenUpdates(false)
            detailVC = toViewController as! DetailViewController
            fromView = fromViewController.view
            alpha = 0
            detailVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
            destTransform = CGAffineTransformMakeScale(1, 1)
            snapshotImageView.frame = originalView!.frame
        } else if navigationOperation == UINavigationControllerOperation.Pop {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            detailVC = fromViewController as! DetailViewController
            snapshotImageView = detailVC.detailImageView?.snapshotViewAfterScreenUpdates(false)
            fromView = toViewController.view
            // 如果IDE是Xcode6 Beta4+iOS8SDK，那么在此处设置为0，动画将会不被执行(不确定是哪里的Bug)
            destTransform = CGAffineTransformMakeScale(0.1, 0.1)
            snapshotImageView.frame = detailVC.detailImageView!.frame
        }
        originalView?.hidden = true
        detailVC.detailImageView?.hidden = true
        
        containerView.addSubview(snapshotImageView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            detailVC.view.transform = destTransform
            fromView.alpha = alpha
            if self.navigationOperation == UINavigationControllerOperation.Push {
                snapshotImageView.frame = detailVC.detailImageView!.frame
            } else if self.navigationOperation == UINavigationControllerOperation.Pop {
                snapshotImageView.frame = originalView!.frame
            }
        }, completion: ({completed in
            originalView?.hidden = false
            detailVC.detailImageView?.hidden = false
            snapshotImageView.removeFromSuperview()
            //告诉系统你的动画过程已经结束，这是非常重要的方法，必须调用。
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }))
    }
    
}

