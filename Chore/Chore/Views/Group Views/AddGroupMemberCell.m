//
//  AddGroupMemberCell.m
//  Chore
//
//  Created by Alice Park on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AddGroupMemberCell.h"


@implementation AddGroupMemberCell

- (IBAction)didTapAdd:(id)sender {
    
    [self.delegate addMember:self];
    
}



@end
