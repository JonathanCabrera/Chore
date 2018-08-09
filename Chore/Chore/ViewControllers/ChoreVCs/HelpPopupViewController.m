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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
