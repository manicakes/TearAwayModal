//
//  TearAwayModalController.m
//  TearAwayModalView
//
//  Created by Mani Ghasemlou on 2016-06-07.
//  Copyright © 2016 Mani Ghasemlou. All rights reserved.
//

#import "TearAwayController.h"
#import "TearAwayModalVC.h"

@interface
TearAwayController ()
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIViewController* presentingVC;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* view;
@property (nonatomic, strong) TearAwayModalVC* modalVC;
@property (nonatomic, strong) TearAwayDismissBlock dismiss;
@end

@implementation TearAwayController

- (void)presentView:(UIView*)contentView
 fromViewController:(UIViewController*)vc
          dismissed:(TearAwayDismissBlock)dismissedBlock
{
  [self presentView:contentView
        withScrollView:nil
    fromViewController:vc
             dismissed:dismissedBlock];
}

- (void)presentView:(UIView*)contentView
     withScrollView:(UIScrollView*)scrollView
 fromViewController:(UIViewController*)vc
          dismissed:(TearAwayDismissBlock)dismissBlock
{
  self.dismiss = dismissBlock;
  self.contentView = contentView;
  self.scrollView = scrollView;
  self.presentingVC = vc;
  [self initializeModal];
  [self displayContent];
}

- (void)initializeModal
{
  self.view = [[UIView alloc] initWithFrame:self.presentingVC.view.bounds];
  self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
  self.modalVC = [[TearAwayModalVC alloc] init];
  self.modalVC.dismissBlock = self.dismiss;
  self.modalVC.scrollView = self.scrollView;
  self.modalVC.view = self.view;
  self.modalVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
}

- (void)displayContent
{
  self.modalVC.contentView = self.contentView;
  [self.presentingVC presentViewController:self.modalVC
                                  animated:NO
                                completion:nil];
}

@end
