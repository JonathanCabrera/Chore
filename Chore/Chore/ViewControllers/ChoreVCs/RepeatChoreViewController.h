//
//  RepeatChoreViewController.h
//  Chore
//
//  Created by Alice Park on 7/31/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RepeatChoreViewControllerDelegate;

@interface RepeatChoreViewController : UIViewController
@property (nonatomic, weak) id<RepeatChoreViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *repeating;
@property (nonatomic, strong) NSString *weekday;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (strong, nonatomic) UIViewController *addChoreVC;

@end

@protocol RepeatChoreViewControllerDelegate

- (void)updateDeadline:(NSDate *)startDate withEndDate:(NSDate *)endDate withFrequency:(NSString *)frequency;

- (void)cancel;

@end
