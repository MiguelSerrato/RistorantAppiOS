//
//  Restaurant.h
//  RistorantApp
//
//  Created by NDM on 10/2/16.
//  Copyright © 2016 NDM. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Restaurant : NSManagedObject

//Properties for the model in the Database
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *open;
@property (nonatomic, retain) NSDate *close;
@property (nonatomic, retain) NSDecimalNumber *price;
@property (nonatomic, retain) NSNumber *rating;
@property (nonatomic, retain) NSString *category;

@end
