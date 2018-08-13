//
//  RepeatChoreViewController.m
//  Chore
//
//  Created by Alice Park on 7/31/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "RepeatChoreViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "LoginViewController.h"
#import "AddChoreViewController.h"

@interface RepeatChoreViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@end

@implementation RepeatChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"EEEE"];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.repeating = @"Does not repeat";
    [self.endDatePicker setHidden:YES];
    [self.endLabel setHidden:YES];
    self.startDate = [NSDate date];
    self.endDate = [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didChangeStartDate:(id)sender {
    self.startDate = self.startDatePicker.date;
    self.weekday = [self.formatter stringFromDate:self.startDate];
    [self.pickerView reloadAllComponents];
}

- (IBAction)didChangeEndDate:(id)sender {
    self.endDate = self.endDatePicker.date;
}

- (IBAction)didTapSave:(id)sender {
    if ([self.startDate compare:self.endDate] == NSOrderedDescending && ![self.repeating isEqualToString:@"Does not repeat"]) {
        [LoginViewController presentAlertWithTitle:@"Start date must occur before end date" fromViewController:self];
    }
    self.weekday = [self.formatter stringFromDate:self.startDate];
    [self.delegate updateDeadline:self.startDate withEndDate:self.endDate withFrequency:self.repeating];
}

- (IBAction)didTapCancel:(id)sender {
    [self.delegate cancel];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    switch(row) {
        case 0:
            title = @"Does not repeat";
            break;
        case 1:
            title = @"Daily";
            break;
        case 2:
            if(self.weekday == nil) {
                title = @"Weekly";
            } else {
                title = [NSString stringWithFormat:@"Weekly on %@", self.weekday];
            }
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(row == 0) {
        self.repeating = @"Does not repeat";
        [self.endDatePicker setHidden:YES];
        [self.endLabel setHidden:YES];
        self.startLabel.text = @"Deadline";
    } else if(row == 1) {
        self.repeating = @"Daily";
        [self.endDatePicker setHidden:NO];
        [self.endLabel setHidden:NO];
        self.startLabel.text = @"Start date";
    } else {
        self.repeating = self.weekday;
        [self.endDatePicker setHidden:NO];
        [self.endLabel setHidden:NO];
        self.startLabel.text = @"Start date";
    }
}

@end
