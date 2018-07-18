//
//  GroupInfoViewController.h
//  Chore
//
//  Created by Alice Park on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Group.h"

@interface GroupInfoViewController : UIViewController

@property (nonatomic, strong) Group *currentGroup;

@end
