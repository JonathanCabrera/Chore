//
//  SettingTableViewController.m
//  
//
//  Created by Jonathan Cabrera on 8/7/18.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Settings";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (IBAction)didTapChangePhoto:(id)sender {
        UIImagePickerController *imagePickerVC = [UIImagePickerController new];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        UIAlertController *pictureViewController = [UIAlertController alertControllerWithTitle:@"Change profile picture" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
        UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Choose from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    
        [pictureViewController addAction:cameraAction];
        [pictureViewController addAction:galleryAction];
        [pictureViewController addAction:cancelAction];
        [self presentViewController:pictureViewController animated:YES completion:nil];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}

@end
