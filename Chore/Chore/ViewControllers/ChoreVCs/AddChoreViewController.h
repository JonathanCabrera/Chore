//
//  AddChoreViewController.h
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "THDatePickerViewController.h"

@interface AddChoreViewController : UIViewController <THDatePickerDelegate>

@property (strong, nonatomic) Group *currentGroup;
@property (nonatomic, strong) THDatePickerViewController *datePicker;
@property (nonatomic, retain) NSDate * currDate;

@end
