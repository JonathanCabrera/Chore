//
//  ProfileViewController.h
//  Chore
//
//  Created by Katie Kwan on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"

@protocol profileViewControllerDelegate;

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) PFUser *selectedUser;
@property (nonatomic) float progress;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end

