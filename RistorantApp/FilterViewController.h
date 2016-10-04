//
//  FilterViewController.h
//  RistorantApp
//
//  Created by NDM on 10/4/16.
//  Copyright © 2016 NDM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface FilterViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate> {
    NSArray *pickerArray;
}
//properties
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOrderName;
@property (weak, nonatomic) IBOutlet UITextField *txtType;
@property (weak, nonatomic) IBOutlet UITextField *txtCategory;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOrderCategory;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentFilterPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtPriceLess;

@property (weak, nonatomic) IBOutlet UITextField *txtPriceGreater;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOrderPrice;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOrderRating;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOrderLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

//action methods
- (IBAction)segmentFilterPriceAction:(id)sender;

@end
