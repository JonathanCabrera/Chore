//
//  LoginViewController.m
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.layer.borderWidth = 0.8f;
    self.loginButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.signupButton.layer.borderWidth = 0.8f;
    self.signupButton.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
