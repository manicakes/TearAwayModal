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
@property (nonatomic, strong) UIView* contentContainer;
@property (nonatomic, strong) UIView* contentMask;
@property (nonatomic, assign) BOOL startedTearing;
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

  self.contentMask = [[UIView alloc] init];
  self.contentMask.backgroundColor = [UIColor lightGrayColor];
  self.contentMask.alpha = 0.0;
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
  self.contentContainer = [[UIView alloc] init];
  self.contentContainer.backgroundColor = [UIColor clearColor];
  self.contentContainer.layer.masksToBounds = NO;
  self.contentContainer.layer.shadowRadius = 20;
  self.contentContainer.layer.shadowOpacity = 0.6;
  self.contentContainer.layer.cornerRadius = self.modalCornerRadius;
  self.contentContainer.frame =
    CGRectInset(self.view.bounds, self.modalInset, self.modalInset);
  [self.view addSubview:self.contentContainer];
  self.contentContainer.frame = self.contentView.frame;
  [self.contentContainer addSubview:contentView];
  self.contentTransform = self.contentContainer.transform;
  // pan gesture init
  self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                     action:@selector(didPan:)];
  self.pan.delegate = self;
  [self.contentContainer addGestureRecognizer:self.pan];

  // dynamics init
  self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
  self.snap = [[UISnapBehavior alloc] initWithItem:self.contentContainer
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

- (BOOL)contentIsAtTop
{
  if (self.scrollView == nil) {
    return YES;
  }

  return self.scrollView.contentOffset.y <= 0;
}

- (BOOL)contentIsAtBottom
{
  if (self.scrollView == nil) {
    return YES;
  }

  return self.scrollView.contentOffset.y >=
         (self.scrollView.contentSize.height -
          self.scrollView.frame.size.height);
}

- (BOOL)contentIsAtLeftMost
{
  if (self.scrollView == nil) {
    return YES;
  }

  return self.scrollView.contentOffset.x == 0;
}

- (BOOL)contentIsAtRightMost
{
  if (self.scrollView == nil) {
    return YES;
  }

  return self.scrollView.contentOffset.x ==
         (self.scrollView.contentSize.width - self.scrollView.frame.size.width);
}

- (BOOL)shouldTearAway:(UIPanGestureRecognizer*)pan
{
  if (self.startedTearing) {
    return YES;
  }

  CGPoint vel = [pan velocityInView:self.view];

  BOOL panVert = fabs(vel.y) > fabs(vel.x);

  BOOL panUp = panVert && vel.y < 0;
  BOOL panDown = panVert && vel.y > 0;
  BOOL panLeft = !panVert && vel.x < 0;
  BOOL panRight = !panVert && vel.x > 0;

  //  NSLog(@"up: %d down: %d left: %d right: %d", panUp, panDown, panLeft,
  //        panRight);

  if ([self contentIsAtTop] && panDown) {
    NSLog(@"CONTENT AT TOP, PANNING DOWN");
    return YES;
  }

  if ([self contentIsAtBottom] && panUp) {
    NSLog(@"CONTENT AT BOTTOM, PANNING UP");
    return YES;
  }

  if ([self contentIsAtLeftMost] && panRight) {
    NSLog(@"CONTENT AT LEFT, PANNING RIGHT");
    return YES;
  }

  if ([self contentIsAtRightMost] && panLeft) {
    NSLog(@"CONTENT AT RIGHT, PANNING LEFT");
    return YES;
  }

  NSLog(@"PAN REJECTED");
  return NO;
}

- (void)didPan:(UIPanGestureRecognizer*)pan
{
  if (pan.state == UIGestureRecognizerStateBegan) {
    if (![self shouldTearAway:pan]) {
      return;
    }
    self.startedTearing = YES;
    if (self.scrollView != nil) {
      self.scrollView.scrollEnabled = NO;
    }
    [self.animator removeBehavior:self.snap];
    self.contentMask.frame = self.contentContainer.bounds;
    [self.contentContainer addSubview:self.contentMask];
    [UIView animateWithDuration:0.5
      animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        self.contentMask.alpha = 0.8;
      }
      completion:^(BOOL finished){
      }];
  } else if (pan.state == UIGestureRecognizerStateChanged) {
    if (!self.startedTearing) {
      return;
    }
    CGPoint locationInView = [pan locationInView:self.view];
    // only scale if we are not in want dismissal state
    if (!self.wantsDismissal) {
      CGPoint translation = [pan translationInView:self.view];
      CGFloat translationDist =
        sqrtf(translation.x * translation.x + translation.y * translation.y);
      self.dismissProgress = MIN(1.0, translationDist / self.dismissDistance);
      self.contentContainer.center = CGPointMake(
        (self.dismissProgress) * (locationInView.x) +
          (1 - self.dismissProgress) * (self.view.center.x + translation.x),
        (self.dismissProgress) * (locationInView.y) +
          (1 - self.dismissProgress) * (self.view.center.y + translation.y));
      CGFloat scaleFactor = MAX(0.4, 1 - self.dismissProgress * 0.6);
      self.contentContainer.transform =
        CGAffineTransformScale(self.contentTransform, scaleFactor, scaleFactor);
      // self.contentView.layer.cornerRadius = 15;
    } else {
      self.contentContainer.center = locationInView;

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
                                 self.contentMask.backgroundColor =
                                   [UIColor redColor];
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
                           self.contentMask.backgroundColor =
                             [UIColor lightGrayColor];
                         }
                         completion:nil];
      }
    }

    if (self.dismissProgress >= 1.0) {
      self.wantsDismissal = YES;
    }
  } else if (pan.state == UIGestureRecognizerStateEnded) {
    if (!self.startedTearing) {
      return;
    }

    self.startedTearing = NO;
    if (!self.overCancelButton) {
      self.wantsDismissal = NO;
      if (self.scrollView != nil) {
        self.scrollView.scrollEnabled = YES;
      }
      // restore everything
      [UIView animateWithDuration:0.3
        delay:0
        usingSpringWithDamping:0.5
        initialSpringVelocity:0
        options:0
        animations:^{
          self.contentContainer.transform = self.contentTransform;
          self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
          self.contentMask.alpha = 0.0;
          // self.contentView.layer.cornerRadius = 0;
        }
        completion:^(BOOL finished) {
          [self.contentMask removeFromSuperview];
        }];

      [self.animator addBehavior:self.snap];
    } else {
      // we let go over the cancel button. time to shut down.
      [UIView animateWithDuration:0.5
                       animations:^{
                         self.contentContainer.alpha = 0.0;
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
