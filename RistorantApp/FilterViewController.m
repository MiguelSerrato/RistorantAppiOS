//
//  FilterViewController.m
//  RistorantApp
//
//  Created by NDM on 10/4/16.
//  Copyright © 2016 NDM. All rights reserved.
//

#import "FilterViewController.h"
#import "Constants.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //add buttons for done and cancel
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(done)];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(cancelView)];
    [self.navigationItem setRightBarButtonItem:btnDone];
    [self.navigationItem setLeftBarButtonItem:btnCancel];
    
    //set title
    [self setTitle:@"Filter"];
    
    //set the input view for picker view
    pickerArray = [[NSArray alloc]initWithObjects:@"", @"Breakfast", @"Food", @"Dinner", nil];
    UIPickerView *myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    _txtType.inputView = myPickerView;
}

//update filter for the table view
- (void)done {
    
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    if (_txtName.text.length > 0) {
        NSPredicate *predicateName =[NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", _txtName.text];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:@"name" ascending:(_segmentOrderName.selectedSegmentIndex == 0)];
        [sortDescriptors addObject:sort];
        [predicates addObject:predicateName];
    }
    
    if (_txtType.text.length > 0) {
        NSPredicate *predicateName =[NSPredicate predicateWithFormat:@"type like[cd] %@", _txtType.text];
        [predicates addObject:predicateName];
    }
    
    if (_txtCategory.text.length > 0) {
        NSPredicate *predicateName =[NSPredicate predicateWithFormat:@"category CONTAINS[cd] %@", _txtCategory.text];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:@"category" ascending:(_segmentOrderCategory.selectedSegmentIndex == 0)];
        [sortDescriptors addObject:sort];
        [predicates addObject:predicateName];
    }
    
    if (_txtLocation.text.length > 0) {
        NSPredicate *predicateName =[NSPredicate predicateWithFormat:@"locationString CONTAINS[cd] %@", _txtLocation.text];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:@"locationString" ascending:(_segmentOrderLocation.selectedSegmentIndex == 0)];
        [sortDescriptors addObject:sort];
        [predicates addObject:predicateName];
    }
    
    if (_segmentOrderRating.selectedSegmentIndex != UISegmentedControlNoSegment) {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:@"rating" ascending:(_segmentOrderRating.selectedSegmentIndex == 0)];
        [sortDescriptors addObject:sort];
    }
    
    if (_txtPriceLess.text.length > 0) {
        NSPredicate *predicateName = nil;
        if (_segmentFilterPrice.selectedSegmentIndex == 0) {
            predicateName =[NSPredicate predicateWithFormat:@"price <= %f", [_txtPriceLess.text doubleValue]];
        }
        else if (_segmentFilterPrice.selectedSegmentIndex == 1) {
            predicateName =[NSPredicate predicateWithFormat:@"price >= %f", [_txtPriceLess.text doubleValue]];
        }
        else if (_segmentFilterPrice.selectedSegmentIndex == 2) {
            predicateName =[NSPredicate predicateWithFormat:@"price >= %f AND price <= %f", [_txtPriceLess.text doubleValue], [_txtPriceGreater.text doubleValue]];
        }
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:@"price" ascending:(_segmentOrderPrice.selectedSegmentIndex == 0)];
        [sortDescriptors addObject:sort];
        [predicates addObject:predicateName];
    }
    
    NSPredicate *predicate =[NSCompoundPredicate andPredicateWithSubpredicates:
                             predicates ];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter postNotificationName:kFilterNotification
                                      object:self
                                    userInfo:@{kUserInfoPredicatesNotification : predicate, kUserInfoSortersNotification : sortDescriptors}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//return to the table view
- (void)cancelView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    if (textField.returnKeyType==UIReturnKeyNext) {
        [textField resignFirstResponder];
        
    }
    return YES;
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    [_txtType setText:[pickerArray objectAtIndex:row]];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentFilterPriceAction:(id)sender {
    if (_segmentFilterPrice.selectedSegmentIndex == 2) {
        _txtPriceGreater.enabled = YES;
    }
    else {
        _txtPriceGreater.enabled = NO;
    }
}


@end
