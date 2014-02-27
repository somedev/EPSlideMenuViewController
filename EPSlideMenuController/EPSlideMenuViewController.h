//
//  EPSlideMenuViewController.h
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

#import <UIKit/UIKit.h>

@class EPSlideMenuViewController;
@interface UIViewController(EPSlideMenuViewControllerExtentions)
- (EPSlideMenuViewController*)rootMenuController;
@end

typedef NS_ENUM(NSInteger, EPSlideMenuAnimationstyle) {
    EPSlideMenuAnimationstyleDefault,
    EPSlideMenuAnimationstyleParallax,
    EPSlideMenuAnimationstyleSlide
};

typedef NS_ENUM(NSInteger, EPSlideMenuState) {
    EPSlideMenuStateClosed,
    EPSlideMenuStateLeftOpened,
    EPSlideMenuStateRightOpened
};

typedef NS_ENUM(NSInteger, EPSlideMenuSwipeBehavior) {
    EPSlideMenuSwipeBehaviorEnabled,
    EPSlideMenuSwipeBehaviorDisabled,
    EPSlideMenuSwipeBehaviorCorner
};

@interface EPSlideMenuViewController : UIViewController

/**
 Animation style
 @description possible states: 
 -EPSlideMenuAnimationstyleDefault sliding animation
 -EPSlideMenuAnimationstyleParallax paralax animation
 -EPSlideMenuAnimationstyleSlide menu slides with center controller
**/
@property (nonatomic, assign) EPSlideMenuAnimationstyle slideAnimationStyle;

/**
 Swipe behavior
 @description possible states:
 -EPSlideMenuSwipeBehaviorEnabled
 -EPSlideMenuSwipeBehaviorDisabled
 -EPSlideMenuSwipeBehaviorCorner swipe enabled only on left or righ corner
*/
@property (nonatomic, assign) EPSlideMenuSwipeBehavior swipeBehavior;

/**
 Multiplier to calculate centerViewController's view x origin for opemed state
 for example for left opened menu state:
 centerViewController.view.frame.origin.x=openMenuSlideWidthMultiplier*centerViewController.view.frame.size.width;
*/
@property (nonatomic, assign) CGFloat openMenuSlideWidthMultiplier;

/**
 Current menu state
**/
@property (nonatomic, assign) EPSlideMenuState currentState;

/**
 Apply shadow to center view
**/
@property (nonatomic, assign) BOOL showShadow;

/**
Main right view controller
**/
@property (nonatomic, readonly) UIViewController *rightViewController;

/**
Main center view controller
**/
@property (nonatomic, readonly) UIViewController *centerViewController;

/**
Left menu view controller
**/
@property (nonatomic, readonly) UIViewController *leftViewController;

- (instancetype)initWithCenterViewController:(UIViewController *)centerController
                              leftController:(UIViewController *)leftController
                             rightController:(UIViewController *)rightController;


/**
 Toggle left menu opened state
 @param animated toggle animated
*/
- (void)toggleLeftMenuAnimated:(BOOL)animated;

/**
 Open left menu
 @param animated toggle animated
*/
- (void)openLeftMenuAnimated:(BOOL)animated;

/**
 Toggle right menu opened state
 @param animated toggle animated
*/
- (void)toggleRightMenuAnimated:(BOOL)animated;

/**
 Open right menu
 @param animated toggle animated
*/
- (void)openRightMenuAnimated:(BOOL)animated;

/**
 Close  menu
 @param animated toggle animated
*/
- (void)closeMenuAnimated:(BOOL)animated;

@end
