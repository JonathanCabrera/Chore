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
#import "ChoreInformationViewController.h"
#import "ChoreInformationCell.h"
#import "ChoreAssignment.h"


@interface ChoreInformationViewController : UIViewController

@property (nonatomic, strong) NSString *groupName;

@property (weak, nonatomic) IBOutlet UIImageView *placeHolderImage;

@property (weak, nonatomic) IBOutlet UIButton *assignChoreButton;
@property (strong, nonatomic) NSMutableArray<ChoreAssignment *> *allAssignments;
@property (strong, nonatomic) NSMutableArray<Chore *> *chores;
@property (weak, nonatomic) IBOutlet UILabel *groupProgressStaticLabel;
@property (strong, nonatomic) ChoreAssignment *assignment;
@property (strong, nonatomic) UIColor *bgColor;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ChoreInformationCell *choreCell;
@property (weak, nonatomic) IBOutlet UIProgressView *groupProgressView;
@property (nonatomic) int points;
@property (nonatomic) long totalChores;
@property (nonatomic) long choresDone;
@property (nonatomic) float memberIncrement;
@property (nonatomic) NSInteger *indexToDelete;
@property (weak, nonatomic) IBOutlet UILabel *choresDoneLabel;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray<Chore *> *overDue;
@property (strong, nonatomic) NSMutableArray<Chore *> *thisWeek;
@property (strong, nonatomic) NSMutableArray<Chore *> *future;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (strong, nonatomic) NSMutableArray *allUsers;
@property (nonatomic) int numberOfUsers;
@property (weak, nonatomic) IBOutlet UILabel *uncompletedChoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *assignButton;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (nonatomic) BOOL hasOverDue;
@property (nonatomic) BOOL hasThisWeek;
@property (nonatomic) BOOL hasFuture;
@property (weak, nonatomic) IBOutlet UILabel *noChoresLabel;
@property (nonatomic) NSMutableArray *sectionsCreated;
@property (nonatomic) BOOL hasReloaded;



@end
