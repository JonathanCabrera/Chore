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

@property (nonatomic, strong) NSString *groupName;

@property (weak, nonatomic) IBOutlet UIImageView *placeHolderImage;

@property (weak, nonatomic) IBOutlet UIButton *assignChoreButton;
@property (weak, nonatomic) IBOutlet UIButton *assignButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (weak, nonatomic) IBOutlet UILabel *noChoresLabel;
@property (weak, nonatomic) IBOutlet UILabel *uncompletedChoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupProgressStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *choresDoneLabel;

@end
