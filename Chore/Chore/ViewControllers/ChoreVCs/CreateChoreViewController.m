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
    self.view.backgroundColor = [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)didTapCreate:(id)sender {
    [DefaultChore makeDefaultChore:self.nameField.text withDescription:self.descriptionField.text withPoints:[self.pointsLabel.text intValue] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"saved default chore");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onSlide:(UISlider *)sender {
    _pointsLabel.text = [NSString stringWithFormat:@"%1.0f", [sender value]];
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
