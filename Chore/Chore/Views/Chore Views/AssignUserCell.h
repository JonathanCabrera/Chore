//
//  AssignUserCell.h
//  Chore
//
//  Created by Alice Park on 7/19/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol AssignUserCellDelegate;

@interface AssignUserCell : UITableViewCell

@property (nonatomic, weak) id<AssignUserCellDelegate> delegate;
@property (nonatomic, strong) PFUser *user;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPointLabel;


- (void) setCell:(PFUser *)user;

@end

@protocol AssignUserCellDelegate

- (void)selectUser: (AssignUserCell *)userCell withUserName: (NSString *)userName;

@end
