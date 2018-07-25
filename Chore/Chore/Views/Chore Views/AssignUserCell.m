//
//  AssignUserCell.m
//  Chore
//
//  Created by Alice Park on 7/19/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AssignUserCell.h"
#import "ChoreAssignment.h"

@implementation AssignUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //TODO: use this for selecting effect
    //[super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCell: (PFUser *)user {
    _user = user;
    self.userNameLabel.text = user.username;
    
    PFQuery *query = [PFQuery queryWithClassName:@"ChoreAssignment"];
    query.limit = 1;
    [query whereKey:@"userName" equalTo:user.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(objects != nil) {
            ChoreAssignment *assignment = objects[0];
            self.userPointLabel.text = [NSString stringWithFormat:@"%d points", assignment.points];
        }
    }];
}

- (IBAction)didTapCheck:(id)sender {
    [self.checkButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    [self.delegate selectUser:self withUserName:self.user.username];
}

@end
