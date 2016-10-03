//
//  RestaurantTableViewCell.h
//  RistorantApp
//
//  Created by NDM on 10/3/16.
//  Copyright © 2016 NDM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Restaurant;

@interface RestaurantTableViewCell : UITableViewCell

//properties for the custom cell
@property (weak, nonatomic) IBOutlet UIImageView *imageRestaurant;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *price;

- (void)setInfoWithRestaurant:(Restaurant *)restaurant;

@end
