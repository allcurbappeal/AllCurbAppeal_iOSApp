//
//  JGLoginViewController.m
//  All Curb Appeal
//
//  Created by Joy on 26/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import "JGLoginViewController.h"

@interface JGLoginViewController ()

@end

@implementation JGLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeReferences];
    httpResponse = [[NSMutableData alloc] init];
    
   // [_txtUserName setText:@"jayantaa.ganguly@gmail.com"];
   // [_txtPassword setText:@"12345678"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Customize UI

- (void)customizeReferences {
    [_loginBtn.layer setCornerRadius:5.0f];
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

- (IBAction)loginAction:(id)sender {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Verifying Credentials...";
    
    
    NSMutableString* requestURL = [[NSMutableString alloc] init];
    [requestURL appendString:WEB_SERVICE_PATH];
    
    NSMutableString* requestBody = [[NSMutableString alloc] init];
    //[requestBody appendString:@"tag=categories"];
    
    [requestBody appendString:@"tag=login&"];
    [requestBody appendString:[NSString stringWithFormat:@"UserName=%@&",_txtUserName.text]];
    [requestBody appendString:[NSString stringWithFormat:@"password=%@",_txtPassword.text]];
    
   /* [requestBody appendString:@"tag=user_register&"];
    [requestBody appendString:[NSString stringWithFormat:@"username=%@&",_txtUserName.text]];
    [requestBody appendString:[NSString stringWithFormat:@"password=%@&",_txtPassword.text]];
    [requestBody appendString:@"fname=joy&"];
    [requestBody appendString:@"lname=ganguly&"];
    [requestBody appendString:@"email=joy@gmail.com"];
    [requestBody appendString:@"country=India&"];
    
    [requestBody appendString:@"zip=700034&"];
    
    [requestBody appendString:@"gender=male&"];
    [requestBody appendString:@"phone=981000000&"];
    
    
    [requestBody appendString:@"year=2001&"];
    [requestBody appendString:@"month=12&"];
    [requestBody appendString:@"day=12"];*/
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithString:requestURL]]];
    
    NSString* requestBodyString = [NSString stringWithString:requestBody];
    NSData *requestData = [NSData dataWithBytes:[requestBodyString UTF8String] length: [requestBodyString length]];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestData];
    
    id aa = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
            
            [self performSegueWithIdentifier:@"Pay2" sender:self];
        }
        else {
            [self showMessage:[dictionary valueForKey:@"message"]];
        }
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self removeHUD];
}

# pragma mark - Reset Password 

- (IBAction)resetPassword:(id)sender {
    [self performSegueWithIdentifier:@"ResetPassword" sender:self];
}

- (void)showMessage:(NSString *)strMsg {
    [self removeHUD];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:strMsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert show];
    
}


@end
