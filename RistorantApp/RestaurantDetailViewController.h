//
//  RestaurantDetailViewController.h
//  RistorantApp
//
//  Created by NDM on 10/3/16.
//  Copyright © 2016 NDM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantDetailViewController : UIViewController <UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSArray *pickerArray;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageRestaurant;
@property (weak, nonatomic) IBOutlet UITextField *nameRestaurant;

@property (weak, nonatomic) IBOutlet UITextField *categoryRestaurant;
@property (weak, nonatomic) IBOutlet UITextField *typeRestaurant;
@property (weak, nonatomic) IBOutlet UITextField *openRestaurant;
@property (weak, nonatomic) IBOutlet UITextField *closeRestaurant;
@property (weak, nonatomic) IBOutlet UITextField *priceRestaurant;
@property (weak, nonatomic) IBOutlet UISlider *ratingRestaurant;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

- (IBAction)sliderValueChanged:(id)sender;

- (IBAction)chooseImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@end
