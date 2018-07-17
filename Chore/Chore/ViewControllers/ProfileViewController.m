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
   
    [self viewWillAppear:true];
    //[self fetchData];
    //self.userNameLabel.text = PFUser.currentUser.username;
     
     
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





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
