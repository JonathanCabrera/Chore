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

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *backgroundColor = [UIColor colorWithRed:0.14 green:0.48 blue:0.48 alpha:1.0];
    [self.signupButton setBackgroundColor:backgroundColor];
    self.signupButton.layer.cornerRadius = self.signupButton.frame.size.width /15;
    self.signupButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
