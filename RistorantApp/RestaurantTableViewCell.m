//
//  RestaurantTableViewCell.m
//  RistorantApp
//
//  Created by NDM on 10/3/16.
//  Copyright © 2016 NDM. All rights reserved.
//

#import "RestaurantTableViewCell.h"
#import "Restaurant.h"
#import "UIImage+Save.h"

@implementation RestaurantTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)setInfoWithRestaurant:(Restaurant *)restaurant {
    //set the values for this cell
    self.name.text = restaurant.name;
    self.price.text = [NSString stringWithFormat:@"$%@", restaurant.price];
    self.category.text = restaurant.category;
    self.imageRestaurant.image = [UIImage loadImageWithName:restaurant.image];
    self.rating.text = restaurant.rating.stringValue;
    
}

@end
