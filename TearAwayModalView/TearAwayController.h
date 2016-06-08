//
//  TearAwayModalController.h
//  TearAwayModalView
//
//  Created by Mani Ghasemlou on 2016-06-07.
//  Copyright © 2016 Mani Ghasemlou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TearAwayCommon.h"
@interface TearAwayController : NSObject
- (void)presentView:(UIView*)contentView fromViewController:(UIViewController*)vc dismissed:(DismissBlock)dismissedBlock;
@end
