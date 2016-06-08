//
//  ViewController.m
//  TearAwayModalView
//
//  Created by Mani Ghasemlou on 2016-06-07.
//  Copyright © 2016 Mani Ghasemlou. All rights reserved.
//

#import "ViewController.h"
#import "TearAwayController.h"

@interface ViewController ()
@property (nonatomic, strong) TearAwayController* tear;
@end

@implementation ViewController
- (IBAction)didTapPresent:(id)sender {
  [self presentModal];
}

- (UIColor*)randomColor {
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
  return color;
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)presentModal {
  UIView* redView = [[UIView alloc] initWithFrame:self.view.bounds];
  redView.backgroundColor = [self randomColor];
  
  self.tear = [[TearAwayController alloc] init];
  [self.tear presentView:redView fromViewController:self dismissed:^{
    NSLog(@"Dismissed!");
  }];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
