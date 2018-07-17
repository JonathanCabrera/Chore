//
//  ProfileViewController.m
//  Chore
//
//  Created by Katie Kwan on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse.h"
#import "ParseUI.h"
#import "UpcomingChoresCell.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *upcomingTableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;

@property (weak, nonatomic) NSArray *upcomingChores;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.upcomingTableView.delegate = self;
    //self.upcomingTableView.dataSource = self;
    [self viewWillAppear:true];
    self.userNameLabel.text = PFUser.currentUser.username;
     
     
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}

- (void) fetchData{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:PFUser.currentUser];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    self.userNameLabel.text = PFUser.currentUser.username;
    
    
    [query includeKeys:@[@"author", @"createdAt"]];
    //[query orderByDescending:@"createdAt"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            //             do something with the array of object returned by the call
//            self.feedArray = posts;
//            [self.collectionView reloadData];
//            [self.refreshControl endRefreshing];
            
            
        } else {
            NSLog(@"%@", error.localizedDescription);
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
