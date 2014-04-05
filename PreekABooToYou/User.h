//
//  User.h
//  PreekABooToYou
//
//  Created by Claire Jencks on 4/5/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * isFriend;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) id photo;
@property (nonatomic, retain) NSString * email;

@end
