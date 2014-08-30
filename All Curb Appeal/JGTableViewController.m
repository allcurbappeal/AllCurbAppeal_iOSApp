//
//  JGTableViewController.m
//  All Curb Appeal
//
//  Created by Joy on 29/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import "JGTableViewController.h"
#import "RadioButton.h"
@interface JGTableViewController ()

@end

@implementation JGTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _maleButton.selected = YES;
    _gender = @"male";
    httpResponse = [[NSMutableData alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

-(IBAction)onRadioBtn:(RadioButton*)sender
{
	NSLog(@"%@",sender.titleLabel.text);
    _gender = [sender.titleLabel.text lowercaseString];
}
-(IBAction)openCountryPicker:(id)sender {

    bIsCountry = YES;
    [self showCountry];
    //[_country becomeFirstResponder];

}
-(IBAction)openDatePicker:(id)sender {

    bIsCountry = NO;
    [self showAction];
    
}

-(void)showCountry
{
    [self dismissKeyboard];
    
    UIActionSheet *asheet = asheet = [[UIActionSheet alloc] initWithTitle:@"Pick your country." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [asheet showInView:[self.view superview]];
    [asheet setFrame:CGRectMake(0, self.view.frame.size.height-383, 320, 340)];
}

-(void)showAction
{
    [self dismissKeyboard];
    
    UIActionSheet *asheet ;
   
        asheet = [[UIActionSheet alloc] initWithTitle:@"Pick the date." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select", nil];
    [asheet showInView:[self.view superview]];
    [asheet setFrame:CGRectMake(0, self.view.frame.size.height-383, 320, 320)];
    
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    NSArray *subviews = [actionSheet subviews];
    
    
    if(!bIsCountry) {
        _dobPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 216)];
        _dobPicker.datePickerMode = UIDatePickerModeDate;
        [_dobPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [actionSheet addSubview:_dobPicker];
        [[subviews objectAtIndex:2] setFrame:CGRectMake(20, 252, 280, 46)];
        [[subviews objectAtIndex:3] setFrame:CGRectMake(20, 312, 280, 46)];
    }
    else {
        
        _ctPicker  = [[CountryPicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        [_ctPicker setDelegate:self];
       
        [actionSheet addSubview:_ctPicker];
        [[subviews objectAtIndex:2] setFrame:CGRectMake(20, 252, 280, 46)];
    }

    
    
    
    
}

- (IBAction)datePickerValueChanged:(id)sender {
    
    NSDate *dob = _dobPicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:dob];
    
    [_birthday setText:dateString];
}

#pragma mark - Country Picker Delegate 
- (void)countryPicker:(__unused CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code
{
    _country.text = name;
    //_codeLabel.text = code;
}
#pragma mark - Table view data source
- (IBAction)registerAction:(id)sender {
    
    if(![self validateEntry])
        return;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Verifying Credentials...";
    
    
    NSMutableString* requestURL = [[NSMutableString alloc] init];
    [requestURL appendString:WEB_SERVICE_PATH];
    
    NSMutableString* requestBody = [[NSMutableString alloc] init];
   
    
    [requestBody appendString:@"tag=user_register&"];
    [requestBody appendString:[NSString stringWithFormat:@"username=%@&",_username.text]];
    [requestBody appendString:[NSString stringWithFormat:@"password=%@&",_password.text]];
    [requestBody appendString:[NSString stringWithFormat:@"fname=%@&",_fname.text]];
    [requestBody appendString:[NSString stringWithFormat:@"lname=%@&",_lname.text]];
    [requestBody appendString:[NSString stringWithFormat:@"email=%@&",_email.text]];
    [requestBody appendString:[NSString stringWithFormat:@"country=%@&",_country.text]];
    
    [requestBody appendString:[NSString stringWithFormat:@"zip=%@&",_zip.text]];
    
    [requestBody appendString:[NSString stringWithFormat:@"gender=%@&",_gender]];
    [requestBody appendString:[NSString stringWithFormat:@"phone=%@&",_phone.text]];
    
    NSArray *bDayArr = [_birthday.text componentsSeparatedByString:@"/"];
    
    
    [requestBody appendString:[NSString stringWithFormat:@"year=%@&",bDayArr[2]]];
    [requestBody appendString:[NSString stringWithFormat:@"month=%@&",bDayArr[1]]];
    [requestBody appendString:[NSString stringWithFormat:@"day=%@",bDayArr[0]]];
    
    
    
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithString:requestURL]]];
    
    NSString* requestBodyString = [NSString stringWithString:requestBody];
    NSData *requestData = [NSData dataWithBytes:[requestBodyString UTF8String] length: [requestBodyString length]];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestData];
    
    id aa = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (BOOL)validateEntry {

   // if()
    BOOL isPassed = YES;
    
    NSArray *arrTexts = [NSArray arrayWithObjects:_username.text,_password.text,_fname.text,_lname.text,_email.text,_country.text,_zip.text,_gender,_phone.text,_birthday.text, nil];
    
    for (NSString *str in arrTexts) {
        
        isPassed = [self blankCheck:str];
        if(!isPassed)
            break;
        
    }
    
    
    
    if(!isPassed) {
        [self showMessage:@"Please enter valid details"];
        return NO;
    }
    else {
        if(![self isValidEmail:_email.text Strict:NO]){
            [self showMessage:@"Please provide valid email "];
            return NO;
        }
        
        if(![_password.text isEqualToString:_confirmPassword.text]){
            [self showMessage:@"Password does not matched"];
            return NO;
        }
        else {
            
            return YES;
        }
        
    }
    
    
    
}

- (BOOL)isValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}

- (BOOL)blankCheck:(NSString *)strText {
    if(strText != nil || ![[strText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
        return YES;
    }
    return NO;
}

- (void)showMessage:(NSString *)strMsg {
    [self removeHUD];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:strMsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert show];

}

-(void)removeHUD {
    [HUD removeFromSuperview];
	HUD = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [httpResponse setLength:0];
}

// Called when data has been received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [httpResponse appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [self removeHUD];
    
    NSString* responseString = [[[NSString alloc] initWithData:httpResponse encoding:NSUTF8StringEncoding] copy];
    
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:httpResponse options:kNilOptions
                                                                 error:&error];
    
    if([dictionary valueForKey:@"success"] != nil){
        if([[dictionary valueForKey:@"success"] integerValue] == 1){
            _userID = [dictionary valueForKey:@"id"];

            [self performSegueWithIdentifier:@"Pay" sender:self];
        }
        else {
            [self showMessage:[dictionary valueForKey:@"message"]];
        }
    }
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self removeHUD];
}


- (void)dismissKeyboard {
    NSArray *arrTexts = [NSArray arrayWithObjects:_username,_password,_fname,_lname,_email,_country,_zip,_phone,_birthday, nil];
    
    for (UITextField *txtF in arrTexts) {
        if([txtF canResignFirstResponder]) {
            [txtF resignFirstResponder];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"Pay"]) {
        JGPayViewController *payVC = [segue destinationViewController];
        payVC.userID = _userID;
    }
    
}


@end
