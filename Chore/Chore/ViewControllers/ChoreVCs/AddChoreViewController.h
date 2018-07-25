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
- (IBAction)onTapDeadline:(id)sender;

@property (strong, nonatomic) Group *currentGroup;
@property (weak, nonatomic) IBOutlet UIButton *deadlineButton;
@property (nonatomic, strong) THDatePickerViewController *datePicker;

@end
