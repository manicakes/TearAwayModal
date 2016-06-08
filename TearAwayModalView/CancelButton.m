//
//  CancelButton.m
//  TearAwayModalView
//
//  Created by Mani Ghasemlou on 2016-06-07.
//  Copyright © 2016 Mani Ghasemlou. All rights reserved.
//

#import "CancelButton.h"

@implementation CancelButton

- (instancetype)init {
  if (self = [super init]) {
    self.backgroundColor = [UIColor clearColor];
    self.on = NO;
  }
  return self;
}

- (void)setOn:(BOOL)on
{
  _on = on;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)frame {
  //// Color Declarations
  UIColor* color = self.on ? [UIColor redColor] : [UIColor lightGrayColor];
  UIColor* lineCol = self.on ? [UIColor whiteColor] : [UIColor blackColor];
  
  //// Oval Drawing
  UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame))];
  [color setFill];
  [ovalPath fill];
  
  
  //// Bezier Drawing
  UIBezierPath* bezierPath = [UIBezierPath bezierPath];
  [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.25000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.75000 * CGRectGetHeight(frame))];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.75000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.25000 * CGRectGetHeight(frame))];
  [lineCol setStroke];
  bezierPath.lineWidth = 5;
  [bezierPath stroke];
  
  
  //// Bezier 2 Drawing
  UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
  [bezier2Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.25000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.25000 * CGRectGetHeight(frame))];
  [bezier2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.75000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.75000 * CGRectGetHeight(frame))];
  [lineCol setStroke];
  bezier2Path.lineWidth = 5;
  [bezier2Path stroke];
}

@end
