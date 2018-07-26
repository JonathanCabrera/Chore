//
//  CreateChoreViewController.m
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "CreateChoreViewController.h"
#import "DefaultChore.h"

@interface CreateChoreViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *pointField;

@end

@implementation CreateChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)didTapCreate:(id)sender {
    
    [DefaultChore makeDefaultChore:self.nameField.text withDescription:self.descriptionField.text withPoints:[self.pointField.text intValue] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"saved default chore");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    self.nameField.text = @"";
    self.descriptionField.text = @"";
    self.pointField.text = @"";
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
