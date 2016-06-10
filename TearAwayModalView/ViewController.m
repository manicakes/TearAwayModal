//
//  ViewController.m
//  TearAwayModalView
//
//  Created by Mani Ghasemlou on 2016-06-07.
//  Copyright © 2016 Mani Ghasemlou. All rights reserved.
//

#import "TearAwayController.h"
#import "ViewController.h"

@interface
ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) TearAwayController* tear;
@end

@implementation ViewController
- (IBAction)didTapPresent:(id)sender
{
  [self presentModal];
}

- (UIColor*)randomColor
{
  CGFloat hue = (arc4random() % 256 / 256.0); //  0.0 to 1.0
  CGFloat saturation =
    (arc4random() % 128 / 256.0) + 0.5; //  0.5 to 1.0, away from white
  CGFloat brightness =
    (arc4random() % 128 / 256.0) + 0.5; //  0.5 to 1.0, away from black
  UIColor* color = [UIColor colorWithHue:hue
                              saturation:saturation
                              brightness:brightness
                                   alpha:1];
  return color;
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)presentModal
{
  UIView* redView = [[UIView alloc] initWithFrame:self.view.bounds];
  redView.backgroundColor = [self randomColor];
  NSString* loremIpsum =
    @"Lorem Ipsum is simply dummy text of the printing and typesetting "
    @"industry. Lorem Ipsum has been the industry's standard dummy text ever "
    @"since the 1500s, when an unknown printer took a galley of type and "
    @"scrambled it to make a type specimen book. It has survived not only "
    @"five centuries, but also the leap into electronic typesetting, "
    @"remaining essentially unchanged. It was popularised in the 1960s with "
    @"the release of Letraset sheets containing Lorem Ipsum passages, and "
    @"more recently with desktop publishing software like Aldus PageMaker "
    @"including versions of Lorem Ipsum.\n\nWhy do we use it?\n\nIt is a long "
    @"established fact that a reader will be distracted by the readable "
    @"content of a page when looking at its layout. The point of using Lorem "
    @"Ipsum is that it has a more-or-less normal distribution of letters, as "
    @"opposed to using 'Content here, content here', making it look like "
    @"readable English. Many desktop publishing packages and web page editors "
    @"now use Lorem Ipsum as their default model text, and a search for "
    @"'lorem ipsum' will uncover many web sites still in their infancy. "
    @"Various versions have evolved over the years, sometimes by accident, "
    @"sometimes on purpose (injected humour and the like)."
    @"Lorem Ipsum is simply dummy text of the printing and typesetting "
    @"industry. Lorem Ipsum has been the industry's standard dummy text ever "
    @"since the 1500s, when an unknown printer took a galley of type and "
    @"scrambled it to make a type specimen book. It has survived not only "
    @"five centuries, but also the leap into electronic typesetting, "
    @"remaining essentially unchanged. It was popularised in the 1960s with "
    @"the release of Letraset sheets containing Lorem Ipsum passages, and "
    @"more recently with desktop publishing software like Aldus PageMaker "
    @"including versions of Lorem Ipsum.\n\nWhy do we use it?\n\nIt is a long "
    @"established fact that a reader will be distracted by the readable "
    @"content of a page when looking at its layout. The point of using Lorem "
    @"Ipsum is that it has a more-or-less normal distribution of letters, as "
    @"opposed to using 'Content here, content here', making it look like "
    @"readable English. Many desktop publishing packages and web page editors "
    @"now use Lorem Ipsum as their default model text, and a search for "
    @"'lorem ipsum' will uncover many web sites still in their infancy. "
    @"Various versions have evolved over the years, sometimes by accident, "
    @"sometimes on purpose (injected humour and the like)."
    @"Lorem Ipsum is simply dummy text of the printing and typesetting "
    @"industry. Lorem Ipsum has been the industry's standard dummy text ever "
    @"since the 1500s, when an unknown printer took a galley of type and "
    @"scrambled it to make a type specimen book. It has survived not only "
    @"five centuries, but also the leap into electronic typesetting, "
    @"remaining essentially unchanged. It was popularised in the 1960s with "
    @"the release of Letraset sheets containing Lorem Ipsum passages, and "
    @"more recently with desktop publishing software like Aldus PageMaker "
    @"including versions of Lorem Ipsum.\n\nWhy do we use it?\n\nIt is a long "
    @"established fact that a reader will be distracted by the readable "
    @"content of a page when looking at its layout. The point of using Lorem "
    @"Ipsum is that it has a more-or-less normal distribution of letters, as "
    @"opposed to using 'Content here, content here', making it look like "
    @"readable English. Many desktop publishing packages and web page editors "
    @"now use Lorem Ipsum as their default model text, and a search for "
    @"'lorem ipsum' will uncover many web sites still in their infancy. "
    @"Various versions have evolved over the years, sometimes by accident, "
    @"sometimes on purpose (injected humour and the like)."
    @"Lorem Ipsum is simply dummy text of the printing and typesetting "
    @"industry. Lorem Ipsum has been the industry's standard dummy text ever "
    @"since the 1500s, when an unknown printer took a galley of type and "
    @"scrambled it to make a type specimen book. It has survived not only "
    @"five centuries, but also the leap into electronic typesetting, "
    @"remaining essentially unchanged. It was popularised in the 1960s with "
    @"the release of Letraset sheets containing Lorem Ipsum passages, and "
    @"more recently with desktop publishing software like Aldus PageMaker "
    @"including versions of Lorem Ipsum.\n\nWhy do we use it?\n\nIt is a long "
    @"established fact that a reader will be distracted by the readable "
    @"content of a page when looking at its layout. The point of using Lorem "
    @"Ipsum is that it has a more-or-less normal distribution of letters, as "
    @"opposed to using 'Content here, content here', making it look like "
    @"readable English. Many desktop publishing packages and web page editors "
    @"now use Lorem Ipsum as their default model text, and a search for "
    @"'lorem ipsum' will uncover many web sites still in their infancy. "
    @"Various versions have evolved over the years, sometimes by accident, "
    @"sometimes on purpose (injected humour and the like).";
  UITextView* textView = [[UITextView alloc] initWithFrame:redView.bounds];
  textView.text = loremIpsum;
  textView.backgroundColor = [UIColor clearColor];
  textView.font = [UIFont fontWithName:textView.font.fontName size:20.0];
  textView.textColor = [self randomColor];
  textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
  [redView addSubview:textView];

  self.tear = [[TearAwayController alloc] init];
  [self.tear presentView:redView
          withScrollView:textView
      fromViewController:self
               dismissed:^{
                 NSLog(@"Dismissed!");
               }];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
