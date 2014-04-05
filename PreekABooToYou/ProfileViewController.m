//
//  ProfileViewController.m
//  PreekABooToYou
//
//  Created by Claire Jencks on 4/4/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "UserCollectionViewCell.h"
#import "DetailProfileViewController.h"

@interface ProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic) NSArray *allUsersArray;


@end

@implementation ProfileViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    //these are very important items 
    self.allUsersArray = [NSArray new];
    
    [self load];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:106/255.0f green:65/255.0f blue:91/255.0f alpha:0.1f];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;


}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allUsersArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserCollectionViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"CellReuseID" forIndexPath:indexPath];
    User *user = self.allUsersArray [indexPath.row];
    UIImage *image = [UIImage imageWithData:user.photo];
    cell.myImageView.image = image;
    return cell;
    
}

#pragma mark CREATING MANAGED OBJECT CONTEXT LOAD DATA METHOD
-(void)load
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    self.allUsersArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    if (!self.allUsersArray.count > 0) {
        User *user1 = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user1.name = @"Claire Montana";
        user1.address = @"21 Goethe St. Chicago, IL 60610";
        user1.phoneNumber = @"206-661-7455";
        user1.email = @"clairejencks@gmail.com";
        //convert photo to date object for object controller context to read
        NSString *pathString1 = [[NSBundle mainBundle] pathForResource:@"clairePhoto" ofType:@".png"];
        NSData *data1 = [NSData dataWithContentsOfFile:pathString1];
        user1.photo = data1;
        
        User *user2 = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user2.name = @"Schmalvin Hildreth";
        user2.address = @"Penthouse Apartment";
        user2.phoneNumber = @"Wouldn't you like to know";
        NSString *pathString2 = [[NSBundle mainBundle] pathForResource:@"calvin" ofType:@".png"];
        NSData *data2 = [NSData dataWithContentsOfFile:pathString2];
        user2.photo = data2;
        
        [self.managedObjectContext save:nil];
        [self load];
    }
    [self.myCollectionView reloadData];
}

#pragma mark -- segue method

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if the sender is the usercollectionview cell then set then display the date on the view in the storyboard (called myCollectionView) of what ever comes out of the index path for the allUsersArray
    if ([sender isKindOfClass:[UserCollectionViewCell class]])
    {
        NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:sender];
        DetailProfileViewController *destination = segue.destinationViewController;
        destination.managedObjectContext = self.managedObjectContext; //passing MOC
        destination.allUsersArray = self.allUsersArray;
        destination.currentIndex = indexPath.row;
    }
}


@end
