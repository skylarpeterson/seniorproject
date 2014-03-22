//
//  LoadingViewController.m
//  One
//
//  Created by Skylar Peterson on 3/12/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "LoadingViewController.h"
#import "Availabilities.h"
#import "SummaryViewController.h"
#import <EventKit/EventKit.h>

@interface LoadingViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) EKEventStore *store;
@property (nonatomic) BOOL presenting;

@end

@implementation LoadingViewController

#define SEGUE_IDENTIFIER @"DocumentLoaded"
- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:DatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note){
                                                      self.document = note.userInfo[DatabaseAvailabilityDocument];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:EKStoreAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note){
                                                      self.store = note.userInfo[EKStoreAvailabilityStore];
                                                  }];
}

- (void)setDocument:(UIManagedDocument *)document
{
    _document = document;
    if (self.store) [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:self];
}

- (void)setStore:(EKEventStore *)store
{
    _store = store;
    if (self.document) [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_IDENTIFIER]) {
        if ([segue.destinationViewController isKindOfClass:[SummaryViewController class]]) {
            SummaryViewController *summaryController = (SummaryViewController *)segue.destinationViewController;
            summaryController.document = self.document;
            summaryController.store = self.store;
            summaryController.transitioningDelegate = self;
            summaryController.modalPresentationStyle = UIModalPresentationCustom;
        }
    }
}

#pragma mark - Transitioning Delegate Methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.presenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presenting = NO;
    return self;
}

#pragma mark - Animated Transitioning Protocol Methods

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

#define ANIMATION_INSET 40.0
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    
    if (self.presenting) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             fromViewController.view.alpha = 0.0;
                         }completion:^(BOOL finished){
                             [transitionContext completeTransition:YES];
                         }];
    } else {
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        toViewController.view.frame = CGRectMake(0.0, toViewController.view.frame.size.height, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             toViewController.view.frame = endFrame;
                             fromViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.65, 0.65);
                         }completion:^(BOOL finished){
                             [transitionContext completeTransition:YES];
                             [toViewController setNeedsStatusBarAppearanceUpdate];
                         }];
    }
}

@end
