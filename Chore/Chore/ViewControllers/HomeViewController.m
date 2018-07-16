//
//  HomeViewController.m
//  Chore
//
//  Created by Katie Kwan on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "HomeViewController.h"
#import <UIKit/UIKit.h>
//#import <QuartzCore/QuartzCore.h"
//#import "Parse.h"
#import "CircleProgressBar.h"


@interface HomeViewController ()
@property (nonatomic) CGFloat progressBarWidth;
@property (strong, nonatomic) IBOutlet CircleProgressBar *progressBar;
@property (nonatomic) UIColor *progressBarProgressColor;
@property (nonatomic) UIColor *progressBarTrackColor;
@property (nonatomic) CGFloat startAngle;

// Hint View Customization (inside progress bar)
@property (nonatomic) BOOL hintHidden;
@property (nonatomic) CGFloat hintViewSpacing;
@property (nonatomic) UIColor *hintViewBackgroundColor;
@property (nonatomic) UIFont *hintTextFont;
@property (nonatomic) UIColor *hintTextColor;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[_progressBar setProgress:(CGFloat)progress animated:(BOOL)animated];
    [_progressBar setHintTextGenerationBlock:^NSString *(CGFloat progress) {
        return [NSString stringWithFormat:@"%.0f / 10 Chores Done", progress * 4];
        
        
    }];
    
    
    
    //[_progressBar setProgress:(CGFloat)progress animated:(BOOL)animated];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)aspects {
    [_progressBar setProgressBarWidth:1];
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
