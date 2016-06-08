//
//  TearAwayModalController.h
//  TearAwayModalView
//
//  Created by Mani Ghasemlou on 2016-06-07.
//  Copyright © 2016 Mani Ghasemlou. All rights reserved.
//

#import "TearAwayCommon.h"
#import <UIKit/UIKit.h>
@interface TearAwayController : NSObject
@property (nonatomic, assign) CGFloat modalInset;
@property (nonatomic, assign) CGFloat modalCornerRadius;

- (void)presentView:(UIView*)contentView
 fromViewController:(UIViewController*)vc
          dismissed:(TearAwayDismissBlock)dismissedBlock;

- (void)presentView:(UIView*)contentView
     withScrollView:(UIScrollView*)scrollView
 fromViewController:(UIViewController*)vc
          dismissed:(TearAwayDismissBlock)dismissBlock;
@end
