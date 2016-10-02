//
//  CoreDataStorage.h
//  RistorantApp
//
//  Created by NDM on 10/2/16.
//  Copyright © 2016 NDM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStorage : NSObject

//Properties
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//Singleton Pattern
+ (instancetype)sharedInstance;

@end
