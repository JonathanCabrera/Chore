//
//  SignupViewController.m
//  Chore
//
//  Created by Alice Park on 7/20/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "SignupViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"

@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLayout];
    UITapGestureRecognizer *hideTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKB)];
    [self.view addGestureRecognizer:hideTapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLayout {
    UIColor *backgroundColor = [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];
    UIColor *darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    UIColor *lightGreenColor = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    [self.signupButton setBackgroundColor:backgroundColor];
    self.signupButton.layer.borderColor = backgroundColor.CGColor;
    self.signupButton.layer.cornerRadius = self.signupButton.frame.size.width /15;
    self.signupButton.clipsToBounds = YES;
    self.signupButton.titleLabel.textColor = darkGreenColor;
    [self.signupButton setTitleColor:darkGreenColor forState:UIControlStateNormal];
    self.titleLabel.textColor = lightGreenColor;
    self.userLabel.textColor = lightGreenColor;
    self.passwordLabel.textColor = lightGreenColor;
}

- (void)dismissKB {
    [self.view endEditing:YES];
}

- (void)registerUser {
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;

    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"user-placeholder"], 1);
    newUser[@"profilePic"] = [PFFile fileWithData:imageData];
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            
            [LoginViewController presentAlertWithTitle:@"Error signing up" fromViewController:self];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else {
            NSLog(@"User registered successfully");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)didTapSignup:(id)sender {
    if([self.usernameField.text isEqual:@""]) {
        [LoginViewController presentAlertWithTitle:@"Please enter a username" fromViewController:self];
    }
    if([self.passwordField.text isEqual:@""]) {
        [LoginViewController presentAlertWithTitle:@"Please enter a password" fromViewController:self];
    }
    [self registerUser];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
