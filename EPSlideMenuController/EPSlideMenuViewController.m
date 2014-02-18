//
//  EPSlideMenuViewController.m
//  EPSlideMenuTest
//
//  Created by Ed on 11.01.14.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Eduard Panasiuk
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPSlideMenuViewController.h"

static CGFloat const kSlideMenuOpenMenuWidthMultiplier =0.8f;
static CGFloat const kSlideMenuClosedMenuWidthMultiplier =0.f;
static CGFloat const kSlideMenuAnimationDuration=0.3f;
static CGFloat const kSlideMenuParallax=0.15f;

@implementation UIViewController(EPSlideMenuViewControllerExtentions)
- (EPSlideMenuViewController*)rootMenuController{
    if (self.parentViewController && [self.parentViewController isKindOfClass:[EPSlideMenuViewController class]]) {
        return (EPSlideMenuViewController*)self.parentViewController;
    }
    return nil;
}
@end

@interface EPSlideMenuViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIViewController *centerViewController;
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;

@property (nonatomic, assign) CGFloat lastTouchX;

@property (nonatomic, strong) NSLayoutConstraint *leftViewConstraintX;
@property (nonatomic, strong) NSLayoutConstraint *rightViewConstraintX;
@property (nonatomic, strong) NSLayoutConstraint *centerViewConstraintX;

- (CGFloat)centerViewConstantForState:(EPSlideMenuState)state;
- (CGFloat)leftMenuViewConstantForState:(EPSlideMenuState)state;


@end

@implementation EPSlideMenuViewController

#pragma mark Init

- (instancetype)initWithCenterViewController:(UIViewController *)centerController
                              leftController:(UIViewController *)leftController
                             rightController:(UIViewController *)rightController {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.centerViewController=centerController;
        self.leftViewController = leftController;
        self.rightViewController=rightController;
        self.openMenuSlideWidthMultiplier = kSlideMenuOpenMenuWidthMultiplier;
        self.closedMenuSlideWidthMultiplier = kSlideMenuClosedMenuWidthMultiplier;
        self.lastTouchX=-1;
        self.currentState=EPSlideMenuStateClosed;
        self.slideAnimationStyle=EPSlideMenuAnimationstyleDefault;
    }
    return self;
}


#pragma mark UIViewController stuff

- (void)viewDidLoad
{
    [super viewDidLoad];

#ifdef DEBUG
    NSAssert(self.centerViewController, @"centerViewController should not be nil");
#endif

    self.view.backgroundColor=[UIColor blackColor];

    self.rightViewConstraintX=[self addViewController:self.rightViewController atIndex:0];
    self.leftViewConstraintX=[self addViewController:self.leftViewController atIndex:1];
    self.centerViewConstraintX=[self addViewController:self.centerViewController atIndex:2];

    UIPanGestureRecognizer* panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    panner.cancelsTouchesInView = YES;
    panner.delegate = self;

    [self.centerViewController.view addGestureRecognizer:panner];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.leftViewController.view layoutIfNeeded];
    [self.centerViewController.view layoutIfNeeded];
    [self.rightViewController.view layoutIfNeeded];
}

#pragma mark support
- (NSLayoutConstraint *)addViewController:(UIViewController *)viewController
                                  atIndex:(NSUInteger)index {
    if(!viewController){
        return nil;
    }
    [self addChildViewController:viewController];
    UIView *view=viewController.view;
    if(index>=self.view.subviews.count){
        [self.view addSubview:view];
    }
    else{
        [self.view insertSubview:view atIndex:index];
    }
    view.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0.0]];
     NSLayoutConstraint *lefConstraint=[NSLayoutConstraint constraintWithItem:view
                                                 attribute:NSLayoutAttributeLeft
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.view
                                                 attribute:NSLayoutAttributeLeft
                                                multiplier:1.0
                                                  constant:0.0];
    [self.view addConstraint:lefConstraint];

    [viewController didMoveToParentViewController:self];
    return lefConstraint;
}

#pragma mark properties
- (void)setOpenMenuSlideWidthMultiplier:(CGFloat)openMenuSlideWidthMultiplier {
    if (openMenuSlideWidthMultiplier >1.f) {
        openMenuSlideWidthMultiplier =1.f;
    }
    else if (openMenuSlideWidthMultiplier <0.f){
        openMenuSlideWidthMultiplier =0.f;
    }
    _openMenuSlideWidthMultiplier = openMenuSlideWidthMultiplier;
}

- (void)setClosedMenuSlideWidthMultiplier:(CGFloat)closedMenuSlideWidthMultiplier {
    if (closedMenuSlideWidthMultiplier >1.f) {
        closedMenuSlideWidthMultiplier =1.f;
    }
    else if (closedMenuSlideWidthMultiplier <0.f){
        closedMenuSlideWidthMultiplier =0.f;
    }
    _closedMenuSlideWidthMultiplier = closedMenuSlideWidthMultiplier;
}

#pragma mark frame calculations
- (CGFloat)centerViewConstantForState:(EPSlideMenuState)state{
    CGFloat constant=self.centerViewConstraintX.constant;
    switch (state) {
        case EPSlideMenuStateClosed:
            constant=self.view.frame.size.width*self.closedMenuSlideWidthMultiplier;
            break;
        case EPSlideMenuStateLeftOpened:
            constant=self.view.frame.size.width*self.openMenuSlideWidthMultiplier;
            break;
        case EPSlideMenuStateRightOpened:
            constant=-self.view.frame.size.width*self.openMenuSlideWidthMultiplier;
            break;
    }
    return constant;
}

- (CGFloat)leftMenuViewConstantForState:(EPSlideMenuState)state{
    CGFloat constant=0;
    switch (state) {
        case EPSlideMenuStateClosed:
            if(self.slideAnimationStyle==EPSlideMenuAnimationstyleParalax){
                constant=-self.view.frame.size.width*kSlideMenuParallax;
            }
            else if(self.slideAnimationStyle==EPSlideMenuAnimationstyleSlide){
                constant=-self.view.frame.size.width;
            }
            break;
        case EPSlideMenuStateLeftOpened:
            constant=self.view.frame.origin.x;
            break;
        case EPSlideMenuStateRightOpened:
            constant=-self.view.frame.size.width;
            break;
    }
    return constant;
}

- (CGFloat)rightMenuViewBoundsForState:(EPSlideMenuState)state{
    CGFloat constant=0;
    switch (state) {
        case EPSlideMenuStateClosed:
            if(self.slideAnimationStyle==EPSlideMenuAnimationstyleParalax){
                constant=self.view.frame.size.width*kSlideMenuParallax;
            }
            else if(self.slideAnimationStyle==EPSlideMenuAnimationstyleSlide){
                constant=self.view.frame.size.width;
            }
            break;
        case EPSlideMenuStateLeftOpened:
            constant=self.view.frame.size.width*self.openMenuSlideWidthMultiplier;
            break;
        case EPSlideMenuStateRightOpened:
            constant=self.view.frame.origin.x;
            break;
    }
    return constant;
}

- (CGFloat)calculateConstWithShift:(CGFloat)shift startvalue:(CGFloat)startvalue endValue:(CGFloat)endValue {
    CGFloat newConst=startvalue + (endValue-startvalue)*shift;
    return newConst;
}
#pragma mark menu toggle actions
- (void)updateToMenuState:(EPSlideMenuState)state animated:(BOOL)animated{
    if(!self.rightViewController && state==EPSlideMenuStateRightOpened)
        return;
    if(!self.leftViewController && state==EPSlideMenuStateLeftOpened)
        return;
    if(self.leftViewController){
        self.leftViewConstraintX.constant= [self leftMenuViewConstantForState:state];
    }
    if(self.rightViewController){
        self.rightViewConstraintX.constant=[self rightMenuViewBoundsForState:state];
    }
    if(self.centerViewController){
        self.centerViewConstraintX.constant= [self centerViewConstantForState:state];
    }
    [UIView animateWithDuration:animated ? kSlideMenuAnimationDuration:0.f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.currentState=state;
                     }];
}


- (void)toggleLeftMenuAnimated:(BOOL)animated{
    [self updateToMenuState:(self.currentState==EPSlideMenuStateClosed)?EPSlideMenuStateLeftOpened:EPSlideMenuStateClosed
                   animated:animated];
}

- (void)toggleRightMenuAnimated:(BOOL)animated {
    [self updateToMenuState:(self.currentState==EPSlideMenuStateClosed)?EPSlideMenuStateRightOpened:EPSlideMenuStateClosed
                   animated:animated];
}

- (void)updateFramesAfterMoveLeft:(BOOL)leftMove {
    CGFloat closedCenterConst= [self centerViewConstantForState:EPSlideMenuStateClosed];
    CGFloat openedCenterConst= [self centerViewConstantForState:EPSlideMenuStateLeftOpened];
    BOOL leftEdgeCross =(self.centerViewConstraintX.constant<=closedCenterConst);
    CGFloat width=openedCenterConst-closedCenterConst;
    CGFloat shift= ABS(self.centerViewConstraintX.constant-closedCenterConst)/width;
    if(shift>1.0)
        shift=1.0;

    if(self.leftViewController){
        EPSlideMenuState nextState=leftMove?(leftEdgeCross?EPSlideMenuStateRightOpened:EPSlideMenuStateClosed):(leftEdgeCross?EPSlideMenuStateRightOpened:EPSlideMenuStateLeftOpened);
        EPSlideMenuState prevState=leftMove?(leftEdgeCross?EPSlideMenuStateRightOpened:EPSlideMenuStateLeftOpened):(leftEdgeCross?EPSlideMenuStateRightOpened:EPSlideMenuStateClosed);
        CGFloat newConst= [self calculateConstWithShift:leftMove?(1-shift):shift
                                             startvalue:[self leftMenuViewConstantForState:prevState]
                                               endValue:[self leftMenuViewConstantForState:nextState]];
        self.leftViewConstraintX.constant=newConst;
    }
    if(self.rightViewController){
        EPSlideMenuState nextState=leftMove?(EPSlideMenuStateClosed):EPSlideMenuStateRightOpened;
        EPSlideMenuState prevState=leftMove?(EPSlideMenuStateRightOpened):EPSlideMenuStateClosed;
        CGFloat newConst= [self calculateConstWithShift:leftMove?(1-shift):shift
                                             startvalue:[self rightMenuViewBoundsForState:prevState]
                                               endValue:[self rightMenuViewBoundsForState:nextState]];
        self.rightViewConstraintX.constant=newConst;
    }
    [self.view layoutIfNeeded];
}

- (void)updateStateAfterMovingFinished {
    if(self.currentState == EPSlideMenuStateLeftOpened){
        if(self.centerViewConstraintX.constant<=(self.view.frame.size.width * self.openMenuSlideWidthMultiplier))
            [self updateToMenuState:EPSlideMenuStateClosed animated:YES];
        else
            [self updateToMenuState:EPSlideMenuStateLeftOpened animated:YES];
    }
    else if(self.currentState == EPSlideMenuStateRightOpened){
        if(self.centerViewController.view.frame.origin.x>=(-self.view.frame.size.width * self.openMenuSlideWidthMultiplier))
            [self updateToMenuState:EPSlideMenuStateClosed animated:YES];
        else
            [self updateToMenuState:EPSlideMenuStateRightOpened animated:YES];
    }
    else{
        if(self.centerViewController.view.frame.origin.x>=(self.view.frame.size.width *0.1))
            [self updateToMenuState:EPSlideMenuStateLeftOpened animated:YES];
        else if(self.centerViewController.view.frame.origin.x<=(-self.view.frame.size.width *0.1))
            [self updateToMenuState:EPSlideMenuStateRightOpened animated:YES];
        else
            [self updateToMenuState:EPSlideMenuStateClosed animated:YES];
    }
}

#pragma mark Orientations
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate{
    return YES;
}

#pragma mark UIGestureRecognizerDelegate
-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer{

    CGPoint selfTouchPoint= [gestureRecognizer locationInView:self.view];
    CGFloat centerConst=self.centerViewConstraintX.constant;
    centerConst+=(selfTouchPoint.x-self.lastTouchX);
    if(centerConst<0 && !self.rightViewController){
        centerConst=0;
    }
    if(centerConst>0 && !self.leftViewController){
        centerConst=0;
    }
    self.centerViewConstraintX.constant=centerConst;
    [self.view layoutIfNeeded];
    [self updateFramesAfterMoveLeft:(self.lastTouchX>selfTouchPoint.x)];
    self.lastTouchX=selfTouchPoint.x;

    //finished
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self updateStateAfterMovingFinished];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint selfTouchPoint= [gestureRecognizer locationInView:self.view];
    self.lastTouchX=selfTouchPoint.x;
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
        shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

@end
