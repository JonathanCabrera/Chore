//
//  CreateChoreViewController.m
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "CreateChoreViewController.h"
#import "Chore.h"

@interface CreateChoreViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *pointField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UISlider *pointSlider;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
- (IBAction)onSlide:(id)sender;

@end

@implementation CreateChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[_pointSlider maximumValue: 10];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (void)presentAlertWithTitle:(NSString *)title fromViewController:(UIViewController *)parentViewController {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {// handle response here.
    }];
    [alertViewController addAction:okAction];
    [parentViewController presentViewController:alertViewController animated:YES completion:nil];
}


- (IBAction)didTapCreate:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMddyyyy"];
    NSDate *date = [formatter dateFromString:self.dateField.text];
 
    
    [Chore makeChore:self.nameField.text withDescription:self.descriptionField.text withPoints:[self.pointsLabel.text intValue] withDeadline:date withDefault:@"YES" withUserName:@"DEFAULT" withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"saved chore");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
    self.nameField.text = @"";
    self.descriptionField.text = @"";
    self.pointField.text = @"";
    self.dateField.text = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSlide:(UISlider *)sender {
    _pointsLabel.text = [NSString stringWithFormat:@"%1.0f", [sender value]];
}
@end
