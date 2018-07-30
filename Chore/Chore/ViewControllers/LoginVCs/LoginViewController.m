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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *fbLoginButton;
    
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fbLoginButton = [[FBSDKLoginButton alloc] init];
    
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:self.fbLoginButton.readPermissions block:^(PFUser *user, NSError *error) {
//        if (!user) {
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        } else if (user.isNew) {
//            [self loadFBData];
//            [self performSegueWithIdentifier:@"newUserSegue" sender:nil];
//        } else {
//            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
//        }
//    }];
    
    [self setLayout];
    UITapGestureRecognizer *hideTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKB)];
    [self.view addGestureRecognizer:hideTapGestureRecognizer];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)loadFBData {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            PFUser *newUser = [PFUser user];
            newUser.username = userData[@"id"];
            newUser[@"fullName"] = userData[@"name"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", userData[@"name"]]];
            newUser[@"profilePicURL"] = pictureURL;

            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (error != nil) {
                    NSLog(@"Error: %@", error.localizedDescription);
                    [LoginViewController presentAlertWithTitle:@"Error signing up" fromViewController:self];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                } else {
                    NSLog(@"User registered successfully");
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self performSegueWithIdentifier:@"signupToCreateGroupSegue" sender:nil];
                }
            }];
            

        }
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
