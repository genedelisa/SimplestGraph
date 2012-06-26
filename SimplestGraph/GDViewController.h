//
//  GDViewController.h
//  SimplestGraph
//
//  Created by Gene De Lisa on 6/26/12.
//  Copyright (c) 2012 Rockhopper Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDViewController : UIViewController

- (IBAction)noteOn:(UIButton *)sender;
- (IBAction)noteOff:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end
