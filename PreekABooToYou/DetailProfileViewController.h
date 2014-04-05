//
//  DetailProfileViewController.h
//  PreekABooToYou
//
//  Created by Claire Jencks on 4/4/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailProfileViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *allUsersArray;
@property NSInteger currentIndex;

@end
