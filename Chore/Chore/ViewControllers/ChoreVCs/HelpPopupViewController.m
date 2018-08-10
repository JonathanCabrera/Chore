//
//  HelpPopupViewController.m
//  Broombroom
//
//  Created by Katie Kwan on 8/9/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "HelpPopupViewController.h"
#import <STPopup/STPopup.h>

@interface HelpPopupViewController ()

@end

@implementation HelpPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentSizeInPopup = CGSizeMake(300, 250);
    self.landscapeContentSizeInPopup = CGSizeMake(400, 250);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
