//
//  TearAwayModalVC.m
//  TearAwayModalView
//
//  Created by Mani Ghasemlou on 2016-06-07.
//  Copyright © 2016 Mani Ghasemlou. All rights reserved.
//

#import "TearAwayCancelButton.h"
#import "TearAwayModalVC.h"

@interface
TearAwayModalVC ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIDynamicAnimator* animator;
@property (nonatomic, strong) UISnapBehavior* snap;
@property (nonatomic, strong) UIPanGestureRecognizer* pan;
@property (nonatomic, assign) CGFloat dismissProgress;
@property (nonatomic, assign) CGAffineTransform contentTransform;
@property (nonatomic, assign) BOOL wantsDismissal;
@property (nonatomic, assign) BOOL overCancelButton;
@property (nonatomic, strong) TearAwayCancelButton* cancelButton;
@property (nonatomic, assign) CGAffineTransform cancelTransform;
@end

@implementation TearAwayModalVC

- (instancetype)init
{
  if (self = [super init]) {
    self.dismissDistance = 100.0;
    self.modalInset = 0;
    self.modalCornerRadius = 0;
  }
  return self;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];

  self.cancelButton = [[TearAwayCancelButton alloc] init];
  self.cancelButton.frame = CGRectMake(0, 0, 80, 80);
  self.cancelButton.center =
    CGPointMake(self.view.center.x, self.view.frame.size.height - 100);
  [self.view addSubview:self.cancelButton];
  self.cancelTransform = self.cancelButton.transform;
  self.cancelButton.alpha = 0.0;
  self.cancelButton.backgroundColor = [UIColor clearColor];
  self.cancelButton.layer.masksToBounds = NO;
  self.cancelButton.layer.shadowRadius = 5;
  self.cancelButton.layer.shadowOpacity = 0.5;
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer
  shouldRecognizeSimultaneouslyWithGestureRecognizer:
    (UIGestureRecognizer*)otherGestureRecognizer
{
  return YES;
}

- (void)setContentView:(UIView*)contentView
{
  if (contentView == _contentView) {
    return;
  }

  if (_contentView != nil) {
    [_contentView removeFromSuperview];
    _contentView = nil;
  }

  _contentView = contentView;
  self.contentView.layer.masksToBounds = NO;
  self.contentView.layer.shadowRadius = 20;
  self.contentView.layer.shadowOpacity = 0.6;
  self.contentView.layer.cornerRadius = self.modalCornerRadius;
  self.contentView.frame =
    CGRectInset(self.view.bounds, self.modalInset, self.modalInset);
  [self.view addSubview:contentView];
  self.contentTransform = self.contentView.transform;
  // pan gesture init
  self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                     action:@selector(didPan:)];
  self.pan.delegate = self;
  [self.contentView addGestureRecognizer:self.pan];

  // dynamics init
  self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
  self.snap = [[UISnapBehavior alloc] initWithItem:self.contentView
                                       snapToPoint:self.view.center];
  [self.animator addBehavior:self.snap];
}

- (void)setWantsDismissal:(BOOL)wantsDismissal
{
  if (_wantsDismissal && !wantsDismissal) {
    _wantsDismissal = wantsDismissal;
    self.cancelButton.alpha = 0.0;
  } else if (!_wantsDismissal && wantsDismissal) {
    // NO to YES
    _wantsDismissal = wantsDismissal;
    // show cancel button
    self.cancelButton.alpha = 1.0;
  }
}

- (BOOL)isCloseToCancelButton:(CGPoint)position
{
  CGFloat cancelDistance = 50;
  CGFloat dX = position.x - self.cancelButton.center.x;
  CGFloat dY = position.y - self.cancelButton.center.y;
  CGFloat dist = sqrtf(dX * dX + dY * dY);
  return dist <= cancelDistance;
}

- (void)didPan:(UIPanGestureRecognizer*)pan
{
  if (pan.state == UIGestureRecognizerStateBegan) {
    [self.animator removeBehavior:self.snap];
    [UIView animateWithDuration:0.5
                     animations:^{
                       self.view.backgroundColor =
                         [UIColor colorWithWhite:0.0 alpha:0.8];
                     }];
  } else if (pan.state == UIGestureRecognizerStateChanged) {
    CGPoint locationInView = [pan locationInView:self.view];
    // only scale if we are not in want dismissal state
    if (!self.wantsDismissal) {
      CGPoint translation = [pan translationInView:self.view];
      CGFloat translationDist =
        sqrtf(translation.x * translation.x + translation.y * translation.y);
      self.dismissProgress = MIN(1.0, translationDist / self.dismissDistance);
      self.contentView.center = CGPointMake(
        (self.dismissProgress) * (locationInView.x) +
          (1 - self.dismissProgress) * (self.view.center.x + translation.x),
        (self.dismissProgress) * (locationInView.y) +
          (1 - self.dismissProgress) * (self.view.center.y + translation.y));
      CGFloat scaleFactor = MAX(0.3, 1 - self.dismissProgress * 0.7);
      self.contentView.transform =
        CGAffineTransformScale(self.contentTransform, scaleFactor, scaleFactor);
      // self.contentView.layer.cornerRadius = 15;
    } else {
      self.contentView.center = locationInView;

      BOOL isCloseToCancelButton = [self isCloseToCancelButton:locationInView];
      if (!self.overCancelButton && isCloseToCancelButton) {
        // we dont want to dismiss right away. user has to hold over cancel
        // button for a small amount of time.
        dispatch_after(
          dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
          dispatch_get_main_queue(), ^{
            CGPoint loc = [self.pan locationInView:self.view];
            if ([self isCloseToCancelButton:loc]) {
              // we went over cancel button, make it bigger
              self.overCancelButton = YES;
              self.cancelButton.on = YES;
              [UIView animateWithDuration:0.5
                                    delay:0
                   usingSpringWithDamping:0.3
                    initialSpringVelocity:0
                                  options:0
                               animations:^{
                                 self.cancelButton.transform =
                                   CGAffineTransformScale(self.cancelTransform,
                                                          1.3, 1.3);
                               }
                               completion:nil];
            }
          });
      } else if (self.overCancelButton && !isCloseToCancelButton) {
        // shrink it
        self.overCancelButton = NO;
        self.cancelButton.on = NO;
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.3
              initialSpringVelocity:0
                            options:0
                         animations:^{
                           self.cancelButton.transform = self.cancelTransform;
                         }
                         completion:nil];
      }
    }

    if (self.dismissProgress >= 1.0) {
      self.wantsDismissal = YES;
    }
  } else if (pan.state == UIGestureRecognizerStateEnded) {
    if (!self.overCancelButton) {
      self.wantsDismissal = NO;
      // restore everything
      [UIView animateWithDuration:0.3
                            delay:0
           usingSpringWithDamping:0.5
            initialSpringVelocity:0
                          options:0
                       animations:^{
                         self.contentView.transform = self.contentTransform;
                         self.view.backgroundColor =
                           [UIColor colorWithWhite:0.0 alpha:1.0];
                         // self.contentView.layer.cornerRadius = 0;
                       }
                       completion:nil];

      [self.animator addBehavior:self.snap];
    } else {
      // we let go over the cancel button. time to shut down.
      [UIView animateWithDuration:0.5
                       animations:^{
                         self.contentView.alpha = 0.0;
                       }];
      [UIView animateWithDuration:0.5
        delay:0
        usingSpringWithDamping:0.3
        initialSpringVelocity:0
        options:0
        animations:^{
          self.cancelButton.transform = self.cancelButton.transform;
        }
        completion:^(BOOL finished) {
          [UIView animateWithDuration:0.3
            animations:^{
              self.view.alpha = 0.0;
            }
            completion:^(BOOL finished) {
              [self dismissViewControllerAnimated:NO
                                       completion:^{
                                         if (self.dismissBlock != nil) {
                                           self.dismissBlock();
                                         }
                                       }];
            }];
        }];
    }
  }
}

@end
