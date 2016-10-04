//
//  RestaurantDetailViewController.m
//  RistorantApp
//
//  Created by NDM on 10/3/16.
//  Copyright © 2016 NDM. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "Constants.h"
#import "LocationViewController.h"
#import "CoreDataStorage.h"
#import "Restaurant.h"
#import "UIImage+Save.h"

@interface RestaurantDetailViewController ()

@end

@implementation RestaurantDetailViewController

@synthesize detailRestaurant;

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
    
    //set the input view for datepicker
    UIDatePicker *datePickerOpen = [[UIDatePicker alloc] init];
    datePickerOpen.datePickerMode = UIDatePickerModeTime;
    [datePickerOpen addTarget:self
                       action:@selector(updateTextFieldOpen:)
             forControlEvents:UIControlEventValueChanged];
    UIDatePicker *datePickerClose = [[UIDatePicker alloc] init];
    datePickerClose.datePickerMode = UIDatePickerModeTime;
    [datePickerClose addTarget:self
                        action:@selector(updateTextFieldClose:)
              forControlEvents:UIControlEventValueChanged];
    self.openRestaurant.inputView = datePickerOpen;
    self.closeRestaurant.inputView = datePickerClose;
    
    //set the input view for picker view
    pickerArray = [[NSArray alloc]initWithObjects:@"Breakfast", @"Food", @"Dinner", nil];
    UIPickerView *myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    _typeRestaurant.inputView = myPickerView;
    
    if (detailRestaurant) {
        [self fillInfo];
        [self setTitle:@"Edit Restaurant"];
    }
    else {
        [self setTitle:@"Add Restaurant"];
    }
}



-(void)updateTextFieldOpen:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm a"];
    _openRestaurant.text = [dateFormatter stringFromDate:sender.date];
}
-(void)updateTextFieldClose:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm a"];
    _closeRestaurant.text = [dateFormatter stringFromDate:sender.date];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

//save or update new record
- (void)done {
    if ([self validateFields]) {
        if (!detailRestaurant) {
            
            NSManagedObjectContext *managedObject = [[CoreDataStorage sharedInstance] managedObjectContext];
            NSEntityDescription *restaurantEntity = [NSEntityDescription entityForName:@"Restaurant"
                                                                inManagedObjectContext:managedObject];
            Restaurant *restaurant = [[Restaurant alloc] initWithEntity:restaurantEntity
                                         insertIntoManagedObjectContext:managedObject];
            
            //set all the properties
            [restaurant setName:self.nameRestaurant.text];
            [restaurant setRating:[NSNumber numberWithInt:[self.ratingLabel.text intValue]]];
            
            NSString *location = [_locationRestaurant text];
            NSRange range1 = [location rangeOfString:@"<"];
            NSRange range2 = [location rangeOfString:@">"];
            NSRange rSub = NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length);
            NSString *sub = [location substringWithRange:rSub];
            [restaurant setLocation:sub];
            
            NSString *locationString = [_locationButton titleForState:UIControlStateNormal];
            range1 = [locationString rangeOfString:@"<"];
            range2 = [locationString rangeOfString:@">"];
            rSub = NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length);
            sub = [locationString substringWithRange:rSub];
            [restaurant setLocationString:sub];
            
            [restaurant setType:self.typeRestaurant.text];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"HH:mm a";
            
            [restaurant setOpen:[dateFormatter dateFromString:self.openRestaurant.text]];
            [restaurant setClose:[dateFormatter dateFromString:self.closeRestaurant.text]];
            [restaurant setPrice:[NSDecimalNumber decimalNumberWithString:self.priceRestaurant.text]];
            [restaurant setCategory:self.categoryRestaurant.text];
            [restaurant setImage:restaurant.name];
            
            [UIImage saveImage:self.imageRestaurant.image withName:restaurant.name];
            
            // save
            if ([managedObject hasChanges]) {
                NSLog(@"[*] Will save %lu restaurants", (unsigned long)[[managedObject insertedObjects] count]);
                [managedObject save:nil];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            detailRestaurant.name = self.nameRestaurant.text;
            
            NSString *location = [_locationButton titleForState:UIControlStateNormal];
            NSRange range1 = [location rangeOfString:@"<"];
            NSRange range2 = [location rangeOfString:@">"];
            NSRange rSub = NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length);
            NSString *sub = [location substringWithRange:rSub];
            
            detailRestaurant.locationString = sub;
            
            NSString *locationCoord = [_locationRestaurant text];
            range1 = [locationCoord rangeOfString:@"<"];
            range2 = [locationCoord rangeOfString:@">"];
            rSub = NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length);
            sub = [locationCoord substringWithRange:rSub];
            
            detailRestaurant.location = sub;
            
            detailRestaurant.type = self.typeRestaurant.text;
            detailRestaurant.category = self.categoryRestaurant.text;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"HH:mm a";
            
            detailRestaurant.open = [dateFormatter dateFromString:self.openRestaurant.text];
            detailRestaurant.close = [dateFormatter dateFromString:self.closeRestaurant.text];
            detailRestaurant.price = [NSDecimalNumber decimalNumberWithString:self.priceRestaurant.text];
            detailRestaurant.rating = [NSNumber numberWithInt:[self.ratingLabel.text intValue]];
            
            detailRestaurant.image = detailRestaurant.name;
            
            [UIImage saveImage:self.imageRestaurant.image withName:detailRestaurant.name];
            
            NSManagedObjectContext *managedObject = [[CoreDataStorage sharedInstance] managedObjectContext];
            if ([managedObject hasChanges]) {
                NSLog(@"[*] Will save %lu restaurants", (unsigned long)[[managedObject insertedObjects] count]);
                [managedObject save:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"You must fill all the fields"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okButton];
        
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
        
    }
    
    
    
    
}

//fill all the fields with the info provided (edit mode)
- (void)fillInfo {
    self.nameRestaurant.text = detailRestaurant.name;
    self.categoryRestaurant.text = detailRestaurant.category;
    self.typeRestaurant.text = detailRestaurant.type;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm a";
    
    self.openRestaurant.text = [dateFormatter stringFromDate:detailRestaurant.open];
    self.closeRestaurant.text = [dateFormatter stringFromDate:detailRestaurant.close];
    
    self.priceRestaurant.text = [NSString stringWithFormat:@"%.02f", [detailRestaurant.price doubleValue]];
    self.ratingLabel.text = [detailRestaurant.rating stringValue];
    self.ratingRestaurant.value = [detailRestaurant.rating floatValue];
    [self.locationButton setTitle:[NSString stringWithFormat:@"Location: <%@>", detailRestaurant.locationString] forState:UIControlStateNormal];
    self.locationRestaurant.text = [NSString stringWithFormat:@"Location: <%@>", detailRestaurant.location];
    self.imageRestaurant.image = [UIImage loadImageWithName:detailRestaurant.image];
    
}

//return to main view
- (void)cancelView {
    if (detailRestaurant) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    //add notification when the view will appear
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(coordinateNotification:)
                               name:kCoordinateNotification
                             object:nil];
}


- (void)coordinateNotification:(NSNotification *)notification {
    //get userinfo dictionary
    NSDictionary *userInfo = [notification userInfo];
    
    //set the text of the button
    [_locationRestaurant setText:[NSString stringWithFormat:@"Location: <%f,%f>", [[userInfo objectForKey:kUserInfoCoordinateLatNotification] doubleValue], [[userInfo objectForKey:kUserInfoCoordinateLonNotification] doubleValue]]];
    [_locationButton setTitle:[NSString stringWithFormat:@"Location: <%@>", [userInfo objectForKey:kUserInfoCoordinateTextNotification]] forState:UIControlStateNormal];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString *location = [_locationRestaurant text];
    
    //if the button's text is equal to location, meaning there is no location, don't set the CoordString from the LocationViewController
    if (![location isEqualToString:@"Location"]) {
        
    
    
        LocationViewController *locationViewController = [segue destinationViewController];
        //get the location if is in edit mode
        NSRange range1 = [location rangeOfString:@"<"];
        NSRange range2 = [location rangeOfString:@">"];
        NSRange rSub = NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length);
        NSString *sub = [location substringWithRange:rSub];
    
        [locationViewController setCoordString:sub];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    if(textField.returnKeyType==UIReturnKeyNext) {
        UIView *next = [[textField superview] viewWithTag:textField.tag+1];
        [next becomeFirstResponder];
    } else if (textField.returnKeyType==UIReturnKeyDone) {
        [textField resignFirstResponder];
        
    }
    return YES;
}

- (BOOL)validateFields {
    BOOL returnValue = YES;
    if (_nameRestaurant.text.length == 0 || _openRestaurant.text.length == 0 || _closeRestaurant.text.length == 0 || _typeRestaurant.text.length == 0 || _priceRestaurant.text.length == 0 || [[_locationButton titleForState:UIControlStateNormal] isEqualToString:@"Location"]) {
        returnValue = NO;
    }
    return returnValue;
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
    [_typeRestaurant setText:[pickerArray objectAtIndex:row]];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

- (IBAction)sliderValueChanged:(id)sender {
    _ratingLabel.text = [NSString stringWithFormat:@"%i", (int)_ratingRestaurant.value];
}

- (IBAction)chooseImage:(id)sender {
    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
    imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickController.delegate=self;
    imagePickController.allowsEditing=TRUE;
    [self.navigationController presentViewController:imagePickController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    _imageRestaurant.image=image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
