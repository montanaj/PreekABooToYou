//
//  FriendsViewController.m
//  PreekABooToYou
//
//  Created by Claire Jencks on 4/6/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import "FriendsViewController.h"
#import "AllProfileViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "User.h"
#import "UserCollectionViewCell.h"
#import "DetailProfileViewController.h"
#import "AddUserViewController.h"

@interface FriendsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSMutableArray *friendsArray;

@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;


@end

@implementation FriendsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //these are very important items
    self.friendsArray = [NSMutableArray new];
    
    [self load];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:106/255.0f green:65/255.0f blue:91/255.0f alpha:0.1f];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:56/255.0f green:82/255.0f blue:223/255.0f alpha:1.0f]};
    
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.friendsArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserCollectionViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"CellReuseID" forIndexPath:indexPath];
    User *user = self.friendsArray [indexPath.row];
    UIImage *image = [UIImage imageWithData:user.photo];
    cell.myImageView.image = image;
    return cell;
    
}

#pragma mark CREATING MANAGED OBJECT CONTEXT LOAD DATA METHOD
-(void)load
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray *tempArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    for (User *user in tempArray)
    {
        if (user.isFriend.boolValue && ![self.friendsArray containsObject:user])
        {
            [self.friendsArray addObject:user];
        }
    }
    if (!tempArray.count > 0) {

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
        user2.address = @"Penthouse 123";
        user2.phoneNumber = @"541-745-7876";
        NSString *pathString2 = [[NSBundle mainBundle] pathForResource:@"calvin" ofType:@".png"];
        NSData *data2 = [NSData dataWithContentsOfFile:pathString2];
        user2.photo = data2;
        
        User *user3 = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user3.name = @"Rachel SK";
        user3.address = @"Ocean Beach";
        user3.phoneNumber = @"719-789-7565";
        NSString *pathString3 = [[NSBundle mainBundle] pathForResource:@"rask" ofType:@".png"];
        NSData *data3 = [NSData dataWithContentsOfFile:pathString3];
        user3.photo = data3;
        
        
        [self askForAddressBookAccess];
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
        destination.currentUsersArray = self.friendsArray;
        destination.currentIndex = indexPath.row;
    }
    else if ([sender isKindOfClass:[UIBarButtonItem class]])
    {
        AddUserViewController *destination = segue.destinationViewController;
        destination.managedObjectContext = self.managedObjectContext;
    }
    
}

#pragma mark -- helper methods

-(void)askForAddressBookAccess
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     if (granted)
                                                     {
                                                         [self addUsersFromAddressBook];
                                                     }
                                                     else
                                                     {
                                                         UIAlertView *importFailedAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't Find Contacts"
                                                                                                                     message:@"If you would like to import your contacts, please change your privacy settings for this app."
                                                                                                                    delegate:self
                                                                                                           cancelButtonTitle:@"Ok"
                                                                                                           otherButtonTitles: nil];
                                                         [importFailedAlert show];
                                                     }
                                                 });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        [self addUsersFromAddressBook];
    }
    else
    {
        UIAlertView *importFailedAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't Find Contacts"
                                                                    message:@"If you would like to import your contacts, please change your privacy settings for this app."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles: nil];
        [importFailedAlert show];
    }
}

-(void)addUsersFromAddressBook
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef people  = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (int i = 0;i<ABAddressBookGetPersonCount(addressBook);i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                   inManagedObjectContext:self.managedObjectContext];
        
        NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person,kABPersonFirstNameProperty));
        NSString *lastName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person,kABPersonLastNameProperty));
        if (!firstName)
        {
            firstName = @"";
        }
        if (!lastName)
        {
            lastName = @"";
        }
        user.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int x = 0; x<ABMultiValueGetCount(phoneNumbers); x++)
        {
            NSString *phoneNumber = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, x));
            if (user.phoneNumber) {
                user.phoneNumber = [NSString stringWithFormat:@"%@\n%@", user.phoneNumber, phoneNumber];
            }
            else
            {
                user.phoneNumber = phoneNumber;
            }
        }
        ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);
        for (int i = 0; i < ABMultiValueGetCount(addresses); i++)
        {
            NSDictionary *address = (NSDictionary *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(addresses, i));
            if (address)
            {
                user.address = [NSString stringWithFormat:@"%@, %@, %@, %@, %@",
                                address[@"Street"],
                                address[@"City"],
                                address[@"State"],
                                address[@"CountryCode"],
                                address[@"ZIP"]];
            }
            else
            {
                user.address = @"";
            }
        }
        ABMultiValueRef emailAdresses = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (int i = 0; i < ABMultiValueGetCount(emailAdresses); i++)
        {
            NSString *emailAdress = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emailAdresses, i));
            NSLog(@"%@", emailAdress);
        }
        
        if (ABPersonHasImageData(person))
        {
            user.photo = (NSData *)CFBridgingRelease(ABPersonCopyImageData(person));
        }
    }
}



@end
