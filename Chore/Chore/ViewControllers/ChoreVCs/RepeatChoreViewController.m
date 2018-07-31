//
//  RepeatChoreViewController.m
//  Chore
//
//  Created by Alice Park on 7/31/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "RepeatChoreViewController.h"
#import <STPopup/STPopup.h>
#import "LoginViewController.h"

@interface RepeatChoreViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end

@implementation RepeatChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentSizeInPopup = CGSizeMake(340, 450);
    self.landscapeContentSizeInPopup = CGSizeMake(400, 500);
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didChangeStartDate:(id)sender {
    self.startDate = self.startDatePicker.date;
}

- (IBAction)didChangeEndDate:(id)sender {
    self.endDate = self.endDatePicker.date;
}




- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSave:(id)sender {
    if(self.startDate == nil) {
        [LoginViewController presentAlertWithTitle:@"Please select a start date" fromViewController:self];
    }
    if(self.endDate == nil) {
        [LoginViewController presentAlertWithTitle:@"Please select an end date" fromViewController:self];
    }
    if ([self.startDate compare:self.endDate] == NSOrderedDescending) {
        NSLog(@"here");
        [LoginViewController presentAlertWithTitle:@"Start date must occur before end date" fromViewController:self];
    }
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
            title = @"Daily";
            break;
        case 1:
            title = @"Weekly";
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"MMM d, yyyy"];
//            NSString *formattedDate = [formatter stringFromDate:self.currDate];
//            self.deadlineButton.titleLabel.text = [NSString stringWithFormat:@"%@", formattedDate];
            break;
        case 2:
            title = @"Monthly";
            break;
    }
    return title;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
