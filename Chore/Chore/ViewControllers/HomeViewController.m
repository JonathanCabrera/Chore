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
@property (weak, nonatomic) IBOutlet UIButton *progressButton;
- (IBAction)onTapProgressButton:(id)sender;





@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //[_progressBar setProgress:(CGFloat)progress animated:(BOOL)animated];
    [_progressBar setHintTextGenerationBlock:^NSString *(CGFloat progress) {
        return [NSString stringWithFormat:@"%.0f / 10 Chores Done", progress * 10];
        
        
        
    }];
    

    

    
    //[_progressBar setProgressBarWidth:25];
    [_progressBar setProgress:100 animated:YES duration:5];
    UIColor *unfinished = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0];
    UIColor *progressColor = [UIColor colorWithRed:0.46 green:0.56 blue:0.80 alpha:1.0];
    UIColor *hintColor =
    [UIColor colorWithRed:0.44 green:0.54 blue:1.00 alpha:1.0];
    UIColor *backgroundColor = [UIColor colorWithRed:0.63 green:0.87 blue:1.00 alpha:1.0];
    [_progressBar setProgressBarProgressColor:progressColor];
    [_progressBar setProgressBarTrackColor:unfinished];
    [_progressBar setHintViewBackgroundColor:hintColor];
    _progressBar.backgroundColor = backgroundColor;
    [_progressBar setStartAngle:270];
    
    
    
    //[_progressBar setProgress:(CGFloat)progress animated:(BOOL)animated];
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


- (IBAction)onTapProgressButton:(id)sender {
    [_progressBar setProgress:0 animated:NO];
    [_progressBar setProgress:100 animated:YES duration:5];
}
@end
