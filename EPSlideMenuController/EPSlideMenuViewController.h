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
    EPSlideMenuAnimationstyleParalax
};

typedef NS_ENUM(NSInteger, EPSlideMenuState) {
    EPSlideMenuStateClosed,
    EPSlideMenuStateLeftOpened,
    EPSlideMenuStateRightOpened
};

@interface EPSlideMenuViewController : UIViewController

/**
 Animation style
 @description possible states: 
 -EPSlideMenuAnimationstyleDefault sliding animation
 -EPSlideMenuAnimationstyleParalax paralax animation
**/
@property (nonatomic, assign) EPSlideMenuAnimationstyle slideAnimationStyle;

@property (nonatomic, assign) CGFloat openMenuSlideWidthMultiplier;

@property (nonatomic, assign) CGFloat closedMenuSlideWidthMultiplier;

@property (nonatomic, assign) EPSlideMenuState currentState;

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


- (void)updateToMenuState:(EPSlideMenuState)state
                 animated:(BOOL)animated;

/**
 Toggle left menu opened state
 @param animated toggle animated
*/
- (void)toggleLeftMenuAnimated:(BOOL)animated;

/**
 Toggle right menu opened state
 @param animated toggle animated
*/
- (void)toggleRightMenuAnimated:(BOOL)animated;

@end
