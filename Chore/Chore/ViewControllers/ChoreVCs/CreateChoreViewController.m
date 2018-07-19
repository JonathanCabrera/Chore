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

@end

@implementation CreateChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTapCreate:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMddyyyy"];
    NSDate *date = [formatter dateFromString:self.dateField.text];
    
    [Chore makeChore:self.nameField.text withDescription:self.descriptionField.text withPoints:[self.pointField.text intValue] withDeadline:date withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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

@end
