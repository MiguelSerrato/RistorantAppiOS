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

@interface RestaurantDetailViewController ()

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //add buttons for done and cancel
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView)];
    [self.navigationItem setRightBarButtonItem:btnDone];
    [self.navigationItem setLeftBarButtonItem:btnCancel];
    
    //set the input view for datepicker
    UIDatePicker *datePickerOpen = [[UIDatePicker alloc] init];
    datePickerOpen.datePickerMode = UIDatePickerModeTime;
    [datePickerOpen addTarget:self action:@selector(updateTextFieldOpen:)
         forControlEvents:UIControlEventValueChanged];
    UIDatePicker *datePickerClose = [[UIDatePicker alloc] init];
    datePickerClose.datePickerMode = UIDatePickerModeTime;
    [datePickerClose addTarget:self action:@selector(updateTextFieldClose:)
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
}



-(void)updateTextFieldOpen:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    _openRestaurant.text = [dateFormatter stringFromDate:sender.date];
}
-(void)updateTextFieldClose:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    _closeRestaurant.text = [dateFormatter stringFromDate:sender.date];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

//save or update new record
- (void)done {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//return to main view
- (void)cancelView {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [_locationButton setTitle:[NSString stringWithFormat:@"Location: <%f,%f>", [[userInfo objectForKey:kUserInfoCoordinateLatNotification] doubleValue], [[userInfo objectForKey:kUserInfoCoordinateLonNotification] doubleValue]] forState:UIControlStateNormal];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString *location = [_locationButton titleForState:UIControlStateNormal];
    
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
        
    } else if (textField.returnKeyType == UIReturnKeyGo) {
        /*if (![self validateFields]) {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Info" message:@"You must fill Email, Phone, First Name and Last Name fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert1 show];
        } else {
            [self performSegueWithIdentifier:@"infoSegue" sender:self];
        }
        */
    }
    return YES;
}

- (BOOL)validateFields {
    BOOL returnValue = YES;
    /*if (_txtLastName.text.length == 0 || _txtFirstName.text.length == 0 || _txtEmail.text.length == 0 || _txtPhone.text.length == 0) {
        returnValue = NO;
    }*/
    return returnValue;
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    _imageRestaurant.image=image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
