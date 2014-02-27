//
//  CenterViewController.m
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
#import "CenterViewController.h"
#import "EPSlideMenuViewController.h"

@interface CenterViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *leftItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(toggleLeft)];
    self.navigationItem.leftBarButtonItem=leftItem;
    UIBarButtonItem *rightItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(toggleRight)];
    self.navigationItem.rightBarButtonItem=rightItem;

    //remove separators for empty cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)toggleLeft {
    EPSlideMenuViewController* controller=[self rootController];
    [controller toggleLeftMenuAnimated:YES];
}

- (void)toggleRight {
    EPSlideMenuViewController* controller=[self rootController];
    [controller toggleRightMenuAnimated:YES];
}

#pragma mark get cuttent rootMenuController
- (EPSlideMenuViewController *)rootController{
    if(self.rootMenuController){
        return self.rootMenuController;
    }
    return self.navigationController.rootMenuController;
}

#pragma mark Orientations
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate{
    return YES;
}

#pragma mark UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return @"Animation style";
    }
    else if(section==1){
        return @"Swipe behavior";
    }
    else if (section == 2) {
        return @"Shadow";
    }
    else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? 1 : 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID=@"CellReusableID";

    UITableViewCell *cell= [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:cellID];
    }
    EPSlideMenuViewController *rootMenuController= [self rootController];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    if(indexPath.section==0){
        switch(indexPath.row){
            case EPSlideMenuAnimationstyleDefault:
                cell.textLabel.text=@"Default";
                cell.detailTextLabel.text=@"EPSlideMenuAnimationstyleDefault";
                cell.accessoryType=(rootMenuController.slideAnimationStyle==EPSlideMenuAnimationstyleDefault)?
                UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
                break;
            case EPSlideMenuAnimationstyleParallax:
                cell.textLabel.text=@"Parallax";
                cell.detailTextLabel.text=@"EPSlideMenuAnimationstyleParallax";
                cell.accessoryType=(rootMenuController.slideAnimationStyle== EPSlideMenuAnimationstyleParallax)?
                        UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
                break;
            case EPSlideMenuAnimationstyleSlide:
                cell.textLabel.text=@"Slide";
                cell.detailTextLabel.text=@"EPSlideMenuAnimationstyleSlide";
                cell.accessoryType=(rootMenuController.slideAnimationStyle==EPSlideMenuAnimationstyleSlide)?
                        UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        switch(indexPath.row){
            case EPSlideMenuSwipeBehaviorEnabled:
                cell.textLabel.text=@"Enabled";
                cell.detailTextLabel.text=@"EPSlideMenuSwipeBehaviorEnabled";
                cell.accessoryType=(rootMenuController.swipeBehavior==EPSlideMenuSwipeBehaviorEnabled)?
                        UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
                break;
            case EPSlideMenuSwipeBehaviorDisabled:
                cell.textLabel.text=@"Disabled";
                cell.detailTextLabel.text=@"EPSlideMenuSwipeBehaviorDisabled";
                cell.accessoryType=(rootMenuController.swipeBehavior==EPSlideMenuSwipeBehaviorDisabled)?
                        UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
                break;
            case EPSlideMenuSwipeBehaviorCorner:
                cell.textLabel.text=@"Corner";
                cell.detailTextLabel.text=@"EPSlideMenuSwipeBehaviorCorner";
                cell.accessoryType=(rootMenuController.swipeBehavior==EPSlideMenuSwipeBehaviorCorner)?
                        UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 2) {
        cell.textLabel.text = rootMenuController.showShadow ? @"Shown" : @"Hidden";
        cell.detailTextLabel.text = @"show shadow";
        cell.accessoryType = (rootMenuController.showShadow) ?
                UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }

    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EPSlideMenuViewController *rootMenuController= [self rootController];
    if(indexPath.section==0){
        switch(indexPath.row){
            case EPSlideMenuAnimationstyleDefault:
                rootMenuController.slideAnimationStyle=EPSlideMenuAnimationstyleDefault;
                break;
            case EPSlideMenuAnimationstyleParallax:
                rootMenuController.slideAnimationStyle= EPSlideMenuAnimationstyleParallax;
                break;
            case EPSlideMenuAnimationstyleSlide:
                rootMenuController.slideAnimationStyle=EPSlideMenuAnimationstyleSlide;
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        switch(indexPath.row){
            case EPSlideMenuSwipeBehaviorEnabled:
                rootMenuController.swipeBehavior=EPSlideMenuSwipeBehaviorEnabled;
                break;
            case EPSlideMenuSwipeBehaviorDisabled:
                rootMenuController.swipeBehavior=EPSlideMenuSwipeBehaviorDisabled;
                break;
            case EPSlideMenuSwipeBehaviorCorner:
                rootMenuController.swipeBehavior=EPSlideMenuSwipeBehaviorCorner;
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 2) {
        rootMenuController.showShadow = !rootMenuController.showShadow;
    }
    [self.tableView reloadData];
}


@end
