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
    
    [self registerAction:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerAction:(id)sender {
    

    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Uploading Data...";
    
     mObj = [JGMainObject sharedInstance];
    [mObj setCardType:@"Visa"];
    [mObj setCardNumber:@"1234567887654321"];
    [mObj setExpirationMonth:12];
    [mObj setExpirationYear:2016];
    [mObj setCvv:@"123"];
    [mObj setTicketNO:@"1111"];
    [mObj setCat_id:1];
    [mObj setComment:@"Sample Comment"];
    
    UIImage *img = [UIImage imageNamed:@"dog.jpg"];
    NSData *data = UIImageJPEGRepresentation(img, 80);
    
    NSURL *url = [NSURL URLWithString:WEB_SERVICE_PATH];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:@"detail_info" forKey:@"tag"];
    [request setPostValue:_userID forKey:@"userid"];
    [request setPostValue:mObj.cardType forKey:@"card"];
    [request setPostValue:mObj.cardNumber forKey:@"card_no"];
    [request setPostValue:[NSNumber numberWithInteger:mObj.expirationMonth] forKey:@"Exp_date"];
    [request setPostValue:[NSNumber numberWithInteger:mObj.expirationYear] forKey:@"Exp_year"];
    [request setPostValue:mObj.cvv forKey:@"cvv_no"];
    
    [request setPostValue:mObj.ticketNO forKey:@"ticketno"];
    [request setPostValue:[NSNumber numberWithInteger:mObj.cat_id] forKey:@"categories_id"];
    [request setPostValue:mObj.comment forKey:@"comment"];
    
    
    
    [request setData:data withFileName:@"Img1.jpg" andContentType:@"image/jpeg" forKey:@"file1"];
    [request setData:data withFileName:@"Img2.jpg" andContentType:@"image/jpeg" forKey:@"file2"];
    [request setData:data withFileName:@"Img3.jpg" andContentType:@"image/jpeg" forKey:@"file3"];
    [request setData:data withFileName:@"Img4.jpg" andContentType:@"image/jpeg" forKey:@"file4"];
    
    
    
    
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self removeHUD];
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
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
    
//    if([dictionary valueForKey:@"success"] != nil){
//        if([[dictionary valueForKey:@"success"] integerValue] == 1){
//            _userID = [dictionary valueForKey:@"id"];
//            
//            [self performSegueWithIdentifier:@"Pay" sender:self];
//        }
//        else {
//            [self showMessage:[dictionary valueForKey:@"message"]];
//        }
//    }
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self removeHUD];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
