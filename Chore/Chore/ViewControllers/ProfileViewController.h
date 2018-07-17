//
//  ProfileViewController.h
//  Chore
//
//  Created by Katie Kwan on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"

@protocol ProfileViewControllerDelegate
@end

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
//@property (nonatomic, strong) PFFile *image;

- (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image;



//@property (nonatomic, strong) id<ProfileViewControllerDelegate> delegate;

@end

