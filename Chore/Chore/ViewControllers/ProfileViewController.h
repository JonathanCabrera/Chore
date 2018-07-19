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
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
- (void)setName:(PFUser *)user;
@end

