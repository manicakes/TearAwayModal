//
//  TearAwayModalVC.h
//  TearAwayModalView
//
//  Created by Mani Ghasemlou on 2016-06-07.
//  Copyright © 2016 Mani Ghasemlou. All rights reserved.
//

#import "TearAwayCommon.h"
#import <UIKit/UIKit.h>
@interface TearAwayModalVC : UIViewController
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, assign) CGFloat dismissDistance;
@property (nonatomic, strong) TearAwayDismissBlock dismissBlock;
@property (nonatomic, assign) CGFloat modalInset;
@property (nonatomic, assign) CGFloat modalCornerRadius;
@end
