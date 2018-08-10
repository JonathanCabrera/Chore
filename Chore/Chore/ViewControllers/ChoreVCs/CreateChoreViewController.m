//
//  CreateChoreViewController.m
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "CreateChoreViewController.h"
#import "DefaultChore.h"
#import <STPopup/STPopup.h>
#import "LoginViewController.h"

@interface CreateChoreViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UISlider *pointSlider;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
- (IBAction)onSlide:(id)sender;

@end

@implementation CreateChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentSizeInPopup = CGSizeMake(300, 250);
    self.landscapeContentSizeInPopup = CGSizeMake(400, 250);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapCreate:(id)sender {
    if ([self.nameField.text isEqualToString:@""]) {
        [LoginViewController presentAlertWithTitle:@"Please enter a chore name" fromViewController:self];
    } else if ([self.descriptionField.text isEqualToString:@""]) {
        [LoginViewController presentAlertWithTitle:@"Please enter a chore description" fromViewController:self];
    } else {
        [DefaultChore makeDefaultChore:self.nameField.text withDescription:self.descriptionField.text withPoints:[self.pointsLabel.text intValue] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded) {
                NSLog(@"saved default chore");
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSlide:(UISlider *)sender {
    _pointsLabel.text = [NSString stringWithFormat:@"%1.0f", [sender value]];
}

@end
