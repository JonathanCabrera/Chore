//
//  GroupOptionsViewController.m
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "GroupOptionsViewController.h"
#import "Group.h"

@interface GroupOptionsViewController ()
@property (weak, nonatomic) IBOutlet UIView *seeGroupView;
@property (weak, nonatomic) IBOutlet UIView *seeChoresView;

@property (weak, nonatomic) IBOutlet UITextField *makeGroupField;
@property (weak, nonatomic) IBOutlet UIButton *makeGroupButton;


@end

@implementation GroupOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    UITapGestureRecognizer *seeGroupRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapSeeGroup)];
    [self.seeGroupView addGestureRecognizer:seeGroupRecognizer];
    
    //UITapGestureRecognizer *seeChoresRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapSeeChores:)];
     
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapSeeGroup {
    
    [self performSegueWithIdentifier:@"groupInfoSegue" sender:self.groupName];
    
}


- (IBAction)didTapMake:(id)sender {
    
    [Group makeGroup:self.makeGroupField.text withCompletion:^(BOOL succeeded, NSError  * _Nullable error) {
        if (succeeded) {
            NSLog(@"Made group!");
        } else {
            NSLog(@"Error making group: %@", error.localizedDescription);
        }
    }];
    
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
