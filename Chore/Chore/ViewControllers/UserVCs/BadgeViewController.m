//
//  BadgeViewController.m
//  Broombroom
//
//  Created by Alice Park on 8/6/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "BadgeViewController.h"

@interface BadgeViewController ()

@end

@implementation BadgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.popupView setValue:@YES forKey:@"hidden"];
    self.popupLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self setBadges];
    [self getUserData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setBadges {
    self.lockImage = [UIImage imageNamed:@"lock (1)"];
    self.oneImage = [UIImage imageNamed:@"one-badge"];
    self.fiveImage = [UIImage imageNamed:@"high-five (1)"];
    self.tenImage = [UIImage imageNamed:@"medal"];
    self.groupImage = [UIImage imageNamed:@"fist (1)"];
    self.kitchenImage = [UIImage imageNamed:@"washing-plate (1)"];
    self.recycleImage = [UIImage imageNamed:@"recycle"];
    self.bathroomImage = [UIImage imageNamed:@"rubber-duck"];
    self.silverImage = [UIImage imageNamed:@"washing-machine"];
    self.goldImage = [UIImage imageNamed:@"broom-badge"];
    
    self.popup = [KLCPopup popupWithContentView:self.popupView showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeNone dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getUserData {
    self.currentUser = [PFUser currentUser];
    PFQuery *userQuery = [PFQuery queryWithClassName:@"ChoreAssignment"];
    userQuery.limit = 1;
    [userQuery whereKey:@"userName" equalTo:self.currentUser.username];
    [userQuery includeKey:@"completedChores"];

    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(object != nil) {
            ChoreAssignment *assignment = (ChoreAssignment *)object;
            self.numPoints = assignment.points;
            self.groupName = assignment.groupName;
            self.completedChores = assignment.completedChores;
            [self checkNumCompleted];
            [self checkGroupCompleted];
            [self checkCompletedChores];
            [self checkPoints];
        }
    }];
}

- (void)checkNumCompleted {
    long choreCount = [self.completedChores count];
    if(choreCount >= 1) {
        [self.oneButton setBackgroundImage:self.oneImage forState:UIControlStateNormal];
    } else {
        [self.oneButton setBackgroundImage:self.lockImage forState:UIControlStateNormal];
    }
    if(choreCount >= 5) {
        [self.fiveButton setBackgroundImage:self.fiveImage forState:UIControlStateNormal];
    } else {
        [self.fiveButton setBackgroundImage:self.lockImage forState:UIControlStateNormal];
    }
    if(choreCount >= 10) {
        [self.tenButton setBackgroundImage:self.tenImage forState:UIControlStateNormal];
    } else {
        [self.tenButton setBackgroundImage:self.lockImage forState:UIControlStateNormal];
    }
}

- (void)checkGroupCompleted {
    PFQuery *query = [PFQuery queryWithClassName:@"ChoreAssignment"];
    query.limit = 30;
    [query whereKey:@"groupName" equalTo:self.groupName];
    [query includeKey:@"uncompletedChores"];
    NSArray *list = [query findObjects];
    NSMutableArray *allUncompletedChores = [NSMutableArray array];
    NSMutableArray *allCompletedChores = [NSMutableArray array];
    for (PFObject *object in list) {
        NSArray *uncompletedChores = [object objectForKey:@"uncompletedChores"];
        [allUncompletedChores addObjectsFromArray:uncompletedChores];
        NSArray *completedChores = [object objectForKey:@"completedChores"];
        [allCompletedChores addObjectsFromArray:completedChores];
    }
    
    if([allUncompletedChores count] == 0 && [allCompletedChores count] != 0) {
        [self.groupButton setBackgroundImage:self.groupImage forState:UIControlStateNormal];
    } else {
        [self.groupButton setBackgroundImage:self.lockImage forState:UIControlStateNormal];
    }
}

- (void)checkCompletedChores {
    BOOL recycle = NO;
    BOOL cleanBathroom = NO;
    BOOL washDishes = NO;
    BOOL unload = NO;
    BOOL setTable = NO;
    for (Chore *currChore in self.completedChores) {
        NSString *name = currChore.name;
        if ([name isEqualToString:@"take out recycling"]) {
            recycle = YES;
        } else if([name isEqualToString:@"clean the bathroom"]) {
            cleanBathroom = YES;
        } else if([name isEqualToString:@"wash the dishes"]) {
            washDishes = YES;
        } else if([name isEqualToString:@"unload the dishwasher"]) {
            unload = YES;
        } else if([name isEqualToString:@"set the table"]) {
            setTable = YES;
        }
    }
    if(recycle) {
        [self.recycleButton setBackgroundImage:self.recycleImage forState:UIControlStateNormal];
    } else {
        [self.recycleButton setBackgroundImage:self.lockImage forState:UIControlStateNormal];
    }
    if(cleanBathroom) {
        [self.bathroomButton setBackgroundImage:self.bathroomImage forState:UIControlStateNormal];
    } else {
        [self.bathroomButton setBackgroundImage:self.lockImage forState:UIControlStateNormal];
    }
    if(washDishes && unload && setTable) {
        [self.kitchenButton setBackgroundImage:self.kitchenImage forState:UIControlStateNormal];
    } else {
        [self.kitchenButton setBackgroundImage:self.lockImage forState:UIControlStateNormal];
    }
}

- (void)checkPoints {
    if(self.numPoints >= 25) {
        [self.silverButton setBackgroundImage:self.silverImage forState:UIControlStateNormal];
    } else {
        [self.silverButton setBackgroundImage:self.lockImage forState:UIControlStateNormal];
    }
    if(self.numPoints >= 50) {
        [self.goldButton setBackgroundImage:self.goldImage forState:UIControlStateNormal];
    } else {
        [self.goldButton setBackgroundImage:self.lockImage forState:UIControlStateNormal];
    }
}

- (IBAction)didTapOne:(id)sender {
    if([self.oneButton.currentBackgroundImage isEqual:self.lockImage]) {
        [self createLockedPopup];
    } else {
        [self createPopup:@"one"];
    }
}

- (IBAction)didTapFive:(id)sender {
    if([self.fiveButton.currentBackgroundImage isEqual:self.lockImage]) {
        [self createLockedPopup];
    } else {
        [self createPopup:@"five"];
    }
}

- (IBAction)didTapTen:(id)sender {
    if([self.tenButton.currentBackgroundImage isEqual:self.lockImage]) {
        [self createLockedPopup];
    } else {
        [self createPopup:@"ten"];
    }
}

- (IBAction)didTapGroup:(id)sender {
    if([self.groupButton.currentBackgroundImage isEqual:self.lockImage]) {
        [self createLockedPopup];
    } else {
        [self createPopup:@"group"];
    }
}

- (IBAction)didTapKitchen:(id)sender {
    if([self.kitchenButton.currentBackgroundImage isEqual:self.lockImage]) {
        [self createLockedPopup];
    } else {
        [self createPopup:@"kitchen"];
    }
}

- (IBAction)didTapRecycle:(id)sender {
    if([self.recycleButton.currentBackgroundImage isEqual:self.lockImage]) {
        [self createLockedPopup];
    } else {
        [self createPopup:@"recycle"];
    }
}

- (IBAction)didTapBathroom:(id)sender {
    if([self.bathroomButton.currentBackgroundImage isEqual:self.lockImage]) {
        [self createLockedPopup];
    } else {
        [self createPopup:@"bathroom"];
    }
}

- (IBAction)didTapSilver:(id)sender {
    if([self.silverButton.currentBackgroundImage isEqual:self.lockImage]) {
        [self createLockedPopup];
    } else {
        [self createPopup:@"silver"];
    }
}

- (IBAction)didTapGold:(id)sender {
    if([self.goldButton.currentBackgroundImage isEqual:self.lockImage]) {
        [self createLockedPopup];
    } else {
        [self createPopup:@"gold"];
    }
}

- (void)createLockedPopup {
    self.popupImage.image = self.lockImage;
    self.popupLabel.text = @"???";
    [self.popupView setValue:@NO forKey:@"hidden"];
    [self.popup show];
}

- (void)createPopup:(NSString *)badge {
    [self.popupView setValue:@NO forKey:@"hidden"];
    if([badge isEqualToString:@"one"]) {
        self.popupImage.image = self.oneImage;
        self.popupLabel.text = @"You completed one chore!";
        [self.popup show];
    } else if([badge isEqualToString:@"five"]) {
        self.popupImage.image = self.fiveImage;
        self.popupLabel.text = @"You completed five chores!";
        [self.popup show];
    } else if([badge isEqualToString:@"ten"]) {
        self.popupImage.image = self.tenImage;
        self.popupLabel.text = @"You completed ten chores!";
        [self.popup show];
    } else if([badge isEqualToString:@"group"]) {
        self.popupImage.image = self.groupImage;
        self.popupLabel.text = @"Your group's chores are done!";
        [self.popup show];
    } else if([badge isEqualToString:@"kitchen"]) {
        self.popupImage.image = self.kitchenImage;
        self.popupLabel.text = @"You completed three kitchen chores!";
        [self.popup show];
    } else if([badge isEqualToString:@"recycle"]) {
        self.popupImage.image = self.recycleImage;
        self.popupLabel.text = @"You took out the recycling!";
        [self.popup show];
    } else if([badge isEqualToString:@"bathroom"]) {
        self.popupImage.image = self.bathroomImage;
        self.popupLabel.text = @"You cleaned the bathroom!";
        [self.popup show];
    } else if([badge isEqualToString:@"silver"]) {
        self.popupImage.image = self.silverImage;
        self.popupLabel.text = @"You earned 25 points!";
        [self.popup show];
    } else if([badge isEqualToString:@"gold"]) {
        self.popupImage.image = self.goldImage;
        self.popupLabel.text = @"You earned 50 points!";
        [self.popup show];
    }
}

@end
