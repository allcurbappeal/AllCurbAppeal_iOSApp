//
//  JGResetViewController.m
//  All Curb Appeal
//
//  Created by Joy on 31/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import "JGResetViewController.h"

@interface JGResetViewController ()

@end

@implementation JGResetViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    httpResponse = [[NSMutableData alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)sendEmailLink:(id)sender {

    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Sending Reset Link...";
    
    
    NSMutableString* requestURL = [[NSMutableString alloc] init];
    [requestURL appendString:WEB_SERVICE_PATH];
    
    NSMutableString* requestBody = [[NSMutableString alloc] init];
    [requestBody appendString:@"tag=forget_password&"];
    [requestBody appendString:[NSString stringWithFormat:@"UserName=%@",_recovery.text]];
    
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
            
            
            [self showMessage:[dictionary valueForKey:@"message"] withTitle:@"Reset Link Sent"];
//            catArr = [data valueForKey:@"categories_name"];
//            catIds = [data valueForKey:@"id"];
//            
//            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Sent" message:@"We will charge 30% of recovery amount" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            //            [alert show];
            
        }
        else {
            [self showMessage:[dictionary valueForKey:@"message"] withTitle:@"Error !"];
        }
    }
    
    
    
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self removeHUD];
}
- (void)removeHUD {
    
    [HUD removeFromSuperview];
	 HUD = nil;
}
- (void)showMessage:(NSString *)strMsg withTitle:(NSString *)strTitle{
    [self removeHUD];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (IBAction)openLinks:(id)sender {
    
    switch ([sender tag]) {
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com"]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com"]];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
            break;
        case 4:
            //[self presentViewController:vc2 animated:YES completion:nil];
            [self performSegueWithIdentifier:@"legal" sender:self];
            break;
        case 5:
            [self performSegueWithIdentifier:@"privacy" sender:self];
            break;
            
        default:
            break;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
