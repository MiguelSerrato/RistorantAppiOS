//
//  UIImage+Save.h
//  RistorantApp
//
//  Created by NDM on 10/3/16.
//  Copyright © 2016 NDM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Save)

+ (void)saveImage: (UIImage*)image withName:(NSString *)name;
+ (UIImage*)loadImageWithName:(NSString *)name;

@end
