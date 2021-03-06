//
//  LoginViewController.m
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *forgotLabel;
@property (weak, nonatomic) IBOutlet UILabel *noAccountLabel;

@end

@implementation LoginViewController

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
    UIColor *lightGreenColor = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.width /20;
    self.loginButton.clipsToBounds = YES;
    self.signupButton.layer.cornerRadius = self.signupButton.frame.size.width /10;
    self.signupButton.clipsToBounds = YES;
    self.titleLabel.textColor = lightGreenColor;
    self.usernameLabel.textColor = lightGreenColor;
    self.passwordLabel.textColor = lightGreenColor;
    self.forgotLabel.textColor = lightGreenColor;
    self.noAccountLabel.textColor = lightGreenColor;
}

- (void)dismissKB {
    [self.view endEditing:YES];
}

+(void)presentAlertWithTitle:(NSString *)title fromViewController:(UIViewController *)parentViewController {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {// handle response here.
    }];
    [alertViewController addAction:okAction];
    [parentViewController presentViewController:alertViewController animated:YES completion:nil];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [LoginViewController presentAlertWithTitle:@"Error logging in" fromViewController:self];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else {
            NSLog(@"User logged in successfully");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(user[@"groupName"] == nil) {
                [self performSegueWithIdentifier:@"newUserSegue" sender:nil];
            } else {
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }
    }];
}

- (IBAction)didSignup:(id)sender {
    [self performSegueWithIdentifier:@"signupSegue" sender:nil];
}

- (IBAction)didLogin:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loginUser];
}

@end
