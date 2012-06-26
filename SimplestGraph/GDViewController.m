//
//  GDViewController.m
//  SimplestGraph
//
//  Created by Gene De Lisa on 6/26/12.
//  Copyright (c) 2012 Rockhopper Technologies. All rights reserved.
//

#import "GDViewController.h"
#import "GDSoundEngine.h"


@interface GDViewController ()
    @property (strong) id soundEngine;
@end

@implementation GDViewController
@synthesize playButton;
@synthesize soundEngine = _soundEngine;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.soundEngine = [[GDSoundEngine alloc] init];
}

- (void)viewDidUnload
{
    [self setPlayButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)noteOn:(UIButton *)sender {
    NSLog(@"on %d", [sender tag]);
    UInt32 velocity = 100;
    [self.soundEngine playNoteOn:[sender tag] :velocity ];
}

- (IBAction)noteOff:(UIButton *)sender {
    NSLog(@"off %d", [sender tag]);
    [self.soundEngine playNoteOff:[sender tag] ];
}
@end
