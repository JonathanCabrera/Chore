//
//  BadgeViewController.h
//  Broombroom
//
//  Created by Alice Park on 8/6/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "KLCPopup.h"
#import "ChoreAssignment.h"

@interface BadgeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveButton;
@property (weak, nonatomic) IBOutlet UIButton *tenButton;
@property (weak, nonatomic) IBOutlet UIButton *groupButton;
@property (weak, nonatomic) IBOutlet UIButton *kitchenButton;
@property (weak, nonatomic) IBOutlet UIButton *recycleButton;
@property (weak, nonatomic) IBOutlet UIButton *bathroomButton;
@property (weak, nonatomic) IBOutlet UIButton *silverButton;
@property (weak, nonatomic) IBOutlet UIButton *goldButton;
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIImageView *popupImage;
@property (weak, nonatomic) IBOutlet UILabel *popupLabel;
@property (strong, nonatomic) KLCPopup *popup;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSMutableArray *completedChores;
@property (strong, nonatomic) NSString *groupName;
@property (strong, nonatomic) UIImage *lockImage;
@property (strong, nonatomic) UIImage *oneImage;
@property (strong, nonatomic) UIImage *fiveImage;
@property (strong, nonatomic) UIImage *tenImage;
@property (strong, nonatomic) UIImage *groupImage;
@property (strong, nonatomic) UIImage *kitchenImage;
@property (strong, nonatomic) UIImage *recycleImage;
@property (strong, nonatomic) UIImage *bathroomImage;
@property (strong, nonatomic) UIImage *silverImage;
@property (strong, nonatomic) UIImage *goldImage;
@property (nonatomic) int numPoints;

@end
