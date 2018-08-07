//
//  ChoreInformationViewController.h
//  Chore
//
//  Created by Jonathan Cabrera on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chore.h"
#import "Group.h"

@interface ChoreInformationViewController : UIViewController

@property (nonatomic, strong) Group *currentGroup;
@property (nonatomic, strong) NSString *groupName;
@property (weak, nonatomic) IBOutlet UIButton *assignChoreButton;

@end
