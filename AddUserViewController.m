//
//  AddUserViewController.m
//  PreekABooToYou
//
//  Created by Claire Jencks on 4/5/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import "AddUserViewController.h"

@interface AddUserViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UITextField *mynameTextField;
@property (strong, nonatomic) IBOutlet UITextField *myCellNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *myEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *myAddressTextField;


@end

@implementation AddUserViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = NO;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
- (IBAction)onAddPhotoPressed:(id)sender
{
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}


@end
