//
//  Constants.h
//  RistorantApp
//
//  Created by NDM on 10/3/16.
//  Copyright © 2016 NDM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject
//notifications
extern NSString * const kCoordinateNotification;
extern NSString * const kFilterNotification;
extern NSString * const kFilterResetNotification;
//notification user info
extern NSString * const kUserInfoCoordinateLatNotification;
extern NSString * const kUserInfoCoordinateLonNotification;
extern NSString * const kUserInfoCoordinateTextNotification;
extern NSString * const kUserInfoPredicatesNotification;
extern NSString * const kUserInfoSortersNotification;
@end
