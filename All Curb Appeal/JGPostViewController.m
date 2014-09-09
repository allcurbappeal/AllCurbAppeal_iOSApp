//
//  JGPostViewController.m
//  All Curb Appeal
//
//  Created by Joy on 30/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import "JGPostViewController.h"

@interface JGPostViewController ()

@end

@implementation JGPostViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    httpResponse = [[NSMutableData alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    if(_isCat)
        [self getCategories:nil];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openCardPicker:(id)sender {
    if(catArr == nil)
        catArr = [NSArray arrayWithObjects:@"Visa",@"Master Card",nil];
    
    self.selectedIndex = 0;
    [ActionSheetStringPicker showPickerWithTitle:@"Select Category" rows:catArr initialSelection:self.selectedIndex target:self successAction:@selector(cardWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (void)cardWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.selectedIndex = [selectedIndex intValue];
    self.reason.text = (catArr)[(NSUInteger) self.selectedIndex];
    self.catID = (catIds)[(NSUInteger) self.selectedIndex];
}
- (void)actionPickerCancelled:(id)sender {
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

- (IBAction)selectPhoto:(UIButton *)sender {
    _imgIndex = [sender tag];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,kUTTypeVideo,kUTTypeImage, nil];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
   // NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //NSLog(@"type=%@",type);
    
    
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    switch (_imgIndex) {
        case 1:
            [self.img1 setImage:chosenImage];
            [[JGMainObject sharedInstance] setFirstImage:self.img1.image];
            break;
        case 2:
            [self.img2 setImage:chosenImage];
            [[JGMainObject sharedInstance] setSecondImage:self.img2.image];
            break;
        case 3:
            [self.img3 setImage:chosenImage];
            [[JGMainObject sharedInstance] setThirdImage:self.img3.image];
            break;
        case 4:
            [self.img4 setImage:chosenImage];
            [[JGMainObject sharedInstance] setFourthImage:self.img4.image];
            break;
            
        default:
            break;
    }
    
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)gotoNextScreen:(id)sender {
    switch ([sender tag]) {
        case 1:
            if([self checkScreenOne])
                [self performSegueWithIdentifier:@"2" sender:self];
            
            break;
        case 2:
            if([self checkScreenTwo]) {
                [[JGMainObject sharedInstance] setTicketNO:_ticketNo.text];
                [self performSegueWithIdentifier:@"3" sender:self];
            }
            
            break;
        case 3:
            if([self checkScreenThree]) {
                [[JGMainObject sharedInstance] setCat_id:[_catID integerValue]];
                [self performSegueWithIdentifier:@"4" sender:self];
            }
            break;
        case 4:
            if([self checkScreenFour]) {
                if([_comment.text length] <= 0)
                    _comment.text = @"No Comments";
                
                [[JGMainObject sharedInstance] setComment:_comment.text];
                [self performSegueWithIdentifier:@"5" sender:self];
            }
            break;
        case 5:
            if([self checkScreenFifth]) {
                [self registerAction:nil];
                //Upload.
            }
            break;
            
        default:
            break;
    }
}

- (BOOL)checkScreenOne {
    if(_img1.image!= nil)
        return YES;
    
    [self showMessage:@"Please upload a image"];
    return NO;
}
- (BOOL)checkScreenTwo {
    if([_ticketNo.text length]>0)
        return YES;
    [self showMessage:@"Please Enter a ticket number"];
    return NO;
}
- (BOOL)checkScreenThree {
    if([_reason.text length]>0)
        return YES;
    [self showMessage:@"Please Select a dismissal reason"];
    return NO;
}
- (BOOL)checkScreenFour {
    
    return YES;
    if([_comment.text length]>0)
        return YES;
    
    [self showMessage:@"Please Enter your comment"];
    return NO;
}
- (BOOL)checkScreenFifth {
   
    if(_img4.image!= nil || _img2.image != nil || _img3.image != nil)
        return YES;
    
    [self showMessage:@"Please upload atleast one image"];
    return NO;
}




- (IBAction)registerAction:(id)sender {
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Uploading Data...";
    mObj = [JGMainObject sharedInstance];

    
    NSURL *url = [NSURL URLWithString:WEB_SERVICE_PATH];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:@"detail_info" forKey:@"tag"];
    [request setPostValue:mObj.userID forKey:@"userid"];
    [request setPostValue:mObj.cardType forKey:@"card"];
    [request setPostValue:mObj.cardNumber forKey:@"card_no"];
    [request setPostValue:[NSNumber numberWithInteger:mObj.expirationMonth] forKey:@"Exp_date"];
    [request setPostValue:[NSNumber numberWithInteger:mObj.expirationYear] forKey:@"Exp_year"];
    [request setPostValue:mObj.cvv forKey:@"cvv_no"];
    
    [request setPostValue:mObj.ticketNO forKey:@"ticketno"];
    [request setPostValue:[NSNumber numberWithInteger:mObj.cat_id] forKey:@"categories_id"];
    [request setPostValue:mObj.comment forKey:@"comment"];
    
    
    NSData *data1 = UIImageJPEGRepresentation(mObj.firstImage, 80);
    NSData *data2 = UIImageJPEGRepresentation(mObj.secondImage, 80);
    NSData *data3 = UIImageJPEGRepresentation(mObj.thirdImage, 80);
    NSData *data4 = UIImageJPEGRepresentation(mObj.fourthImage, 80);
    
    [request setData:data1 withFileName:@"Img1.jpg" andContentType:@"image/jpeg" forKey:@"file1"];
    [request setData:data2 withFileName:@"Img2.jpg" andContentType:@"image/jpeg" forKey:@"file2"];
    [request setData:data3 withFileName:@"Img3.jpg" andContentType:@"image/jpeg" forKey:@"file3"];
    [request setData:data4 withFileName:@"Img4.jpg" andContentType:@"image/jpeg" forKey:@"file4"];
    
    
    [request setDelegate:self];
    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request {
    [self removeHUD];
    // Use when fetching text data
    //NSString *responseString = [request responseString];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions
                                                                 error:nil];
    
    if([dictionary valueForKey:@"success"] != nil){
        if([[dictionary valueForKey:@"success"] integerValue] == 1){
           // NSDictionary *data = [dictionary valueForKey:@"data"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Sent" message:@"We will charge 30% of recovery amount" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

        }
        else {
            [self showMessage:[dictionary valueForKey:@"message"]];
        }
    }
    
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [self removeHUD];
}
- (void)removeHUD {
    [HUD removeFromSuperview];
	HUD = nil;
}

- (void)showMessage:(NSString *)strMsg {
    [self removeHUD];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:strMsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        //Unwind.
        [self performSegueWithIdentifier:@"logout" sender:self];
    }
}

- (void)getCategories:(id)sender {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Loading Categories...";
    
    
    NSMutableString* requestURL = [[NSMutableString alloc] init];
    [requestURL appendString:WEB_SERVICE_PATH];
    
    NSMutableString* requestBody = [[NSMutableString alloc] init];
    [requestBody appendString:@"tag=categories"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithString:requestURL]]];
    
    NSString* requestBodyString = [NSString stringWithString:requestBody];
    NSData *requestData = [NSData dataWithBytes:[requestBodyString UTF8String] length: [requestBodyString length]];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestData];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!theConnection) {
        
        httpResponse = nil;
    }
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
   // NSString* responseString = [[[NSString alloc] initWithData:httpResponse encoding:NSUTF8StringEncoding] copy];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:httpResponse options:kNilOptions
                                                                 error:nil];
    
    if([dictionary valueForKey:@"success"] != nil){
        if([[dictionary valueForKey:@"success"] integerValue] == 1){
             NSDictionary *data = [dictionary valueForKey:@"data"];
            
            catArr = [data valueForKey:@"categories_name"];
            catIds = [data valueForKey:@"id"];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Sent" message:@"We will charge 30% of recovery amount" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            
        }
        else {
            [self showMessage:[dictionary valueForKey:@"message"]];
        }
    }
    
    

    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self removeHUD];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue  identifier] isEqualToString:@"3"]){
        JGPostViewController *pVC = [segue destinationViewController];
        pVC.isCat = YES;
    }
}


@end
