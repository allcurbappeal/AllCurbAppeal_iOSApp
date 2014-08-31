//
//  JGPayViewController.m
//  All Curb Appeal
//
//  Created by Joy on 30/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import "JGPayViewController.h"

@interface JGPayViewController ()

@end

@implementation JGPayViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    httpResponse = [[NSMutableData alloc] init];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[JGMainObject sharedInstance] setUserID:_userID];
   // [self registerAction:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openCardPicker:(id)sender {
    
    [self dismissKeyboard];
    cardArr = [NSArray arrayWithObjects:@"Visa",@"Master Card",nil];
    self.selectedIndex = 0;
     [ActionSheetStringPicker showPickerWithTitle:@"Select Card Type" rows:cardArr initialSelection:self.selectedIndex target:self successAction:@selector(cardWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}
- (IBAction)openDatePicker:(id)sender {
    [self dismissKeyboard];
    monthExpire = [NSArray arrayWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
    NSMutableArray *arrM = [NSMutableArray array];
    for (int m = 2014; m < 2041; m++) {
        [arrM addObject:[NSString stringWithFormat:@"%d",m]];
    }
    yearExpire = arrM;
    self.selectedIndex = 0;
    if([sender tag] == 0) {
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Month" rows:monthExpire initialSelection:self.selectedIndex target:self successAction:@selector(monthWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    }
    if([sender tag] == 1) {
        
        [ActionSheetStringPicker showPickerWithTitle:@"Select Year" rows:yearExpire initialSelection:self.selectedIndex target:self successAction:@selector(yearWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    }
}


- (void)cardWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.selectedIndex = [selectedIndex intValue];
    self.cardType.text = (cardArr)[(NSUInteger) self.selectedIndex];
}

- (void)monthWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.selectedIndex = [selectedIndex intValue];
    self.month = [selectedIndex integerValue] + 1;
    self.monthExpiry.text = (monthExpire)[(NSUInteger) self.selectedIndex];
}
- (void)yearWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.selectedIndex = [selectedIndex intValue];
    self.yearExpiry.text = (yearExpire)[(NSUInteger) self.selectedIndex];
}
- (void)actionPickerCancelled:(id)sender {
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

- (IBAction)saveData:(id)sender {
    
    if(![self validateEntry])
        return;
    
    mObj = [JGMainObject sharedInstance];
    [mObj setCardType:_cardType.text];
    [mObj setCardNumber:_cardNumber.text];
    [mObj setExpirationMonth:self.month];
    [mObj setExpirationYear:[self.yearExpiry.text integerValue]];
    [mObj setCvv:self.cvv.text];
    
    [self performSegueWithIdentifier:@"picture" sender:self];
    
}


- (void)dismissKeyboard {
    NSArray *arrTexts = [NSArray arrayWithObjects:_cardNumber,_cvv, nil];
    
    for (UITextField *txtF in arrTexts) {
        if([txtF canResignFirstResponder]) {
            [txtF resignFirstResponder];
        }
    }
}



//- (IBAction)registerAction:(id)sender {
//    
//
//    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    HUD.labelText = @"Uploading Data...";
//    
//     mObj = [JGMainObject sharedInstance];
//    [mObj setCardType:@"Visa"];
//    [mObj setCardNumber:@"1234567887654321"];
//    [mObj setExpirationMonth:12];
//    [mObj setExpirationYear:2016];
//    [mObj setCvv:@"123"];
//    [mObj setTicketNO:@"1111"];
//    [mObj setCat_id:1];
//    [mObj setComment:@"Sample Comment"];
//    
//    UIImage *img = [UIImage imageNamed:@"dog.jpg"];
//    NSData *data = UIImageJPEGRepresentation(img, 80);
//    
//    NSURL *url = [NSURL URLWithString:WEB_SERVICE_PATH];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setPostFormat:ASIMultipartFormDataPostFormat];
//    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
//    [request setRequestMethod:@"POST"];
//    
//    [request setPostValue:@"detail_info" forKey:@"tag"];
//    [request setPostValue:_userID forKey:@"userid"];
//    [request setPostValue:mObj.cardType forKey:@"card"];
//    [request setPostValue:mObj.cardNumber forKey:@"card_no"];
//    [request setPostValue:[NSNumber numberWithInteger:mObj.expirationMonth] forKey:@"Exp_date"];
//    [request setPostValue:[NSNumber numberWithInteger:mObj.expirationYear] forKey:@"Exp_year"];
//    [request setPostValue:mObj.cvv forKey:@"cvv_no"];
//    
//    [request setPostValue:mObj.ticketNO forKey:@"ticketno"];
//    [request setPostValue:[NSNumber numberWithInteger:mObj.cat_id] forKey:@"categories_id"];
//    [request setPostValue:mObj.comment forKey:@"comment"];
//    
//    
//    
//    [request setData:data withFileName:@"Img1.jpg" andContentType:@"image/jpeg" forKey:@"file1"];
//    [request setData:data withFileName:@"Img2.jpg" andContentType:@"image/jpeg" forKey:@"file2"];
//    [request setData:data withFileName:@"Img3.jpg" andContentType:@"image/jpeg" forKey:@"file3"];
//    [request setData:data withFileName:@"Img4.jpg" andContentType:@"image/jpeg" forKey:@"file4"];
//    
//    
//    
//    
//    [request setDelegate:self];
//    [request startAsynchronous];
//}
//- (void)requestFinished:(ASIHTTPRequest *)request {
//    [self removeHUD];
//    // Use when fetching text data
//    NSString *responseString = [request responseString];
//
//}
//- (void)requestFailed:(ASIHTTPRequest *)request {
//    [self removeHUD];
//}
//- (void)removeHUD {
//    [HUD removeFromSuperview];
//	HUD = nil;
//}


- (BOOL)validateEntry {
    
    // if()
    BOOL isPassed = YES;
    
    NSArray *arrTexts = [NSArray arrayWithObjects:_cardType.text,_cardNumber.text,_monthExpiry.text,_yearExpiry.text,_cvv.text, nil];
    
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
        if(![self isCardNumberValid:_cardNumber.text Strict:NO]){
            [self showMessage:@"Please provide valid Card Number.It Should be 16 digit. "];
            return NO;
        }
        
        else {
            
            return YES;
        }
        
    }
    
    
    
}

- (BOOL)isCardNumberValid:(NSString *)emailString Strict:(BOOL)strictFilter
{
    if([emailString length] == 16)
        return YES;
    
    return NO;
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
- (void)removeHUD {
    [HUD removeFromSuperview];
	HUD = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
