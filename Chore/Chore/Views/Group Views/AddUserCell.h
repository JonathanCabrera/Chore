//
//  AddUserCell.h
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol AddUserCellDelegate;

@interface AddUserCell : UITableViewCell

@property (nonatomic, weak) id<AddUserCellDelegate> delegate;
@property (strong, nonatomic) PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

- (void)setCell:(PFUser *)user;

@end

@protocol AddUserCellDelegate

- (void)selectCell:(AddUserCell *)userCell didSelect:(PFUser *)user;

@end
