//
//  TearAwayModalVC.h
//  TearAwayModalView
//
//  Created by Mani Ghasemlou on 2016-06-07.
//  Copyright © 2016 Mani Ghasemlou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TearAwayCommon.h"
@interface TearAwayModalVC : UIViewController
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, assign) CGFloat dismissDistance;
@property (nonatomic, strong) DismissBlock dismissBlock;
@end
