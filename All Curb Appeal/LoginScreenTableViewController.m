//
//  LoginScreenTableViewController.m
//  Samya
//
//  Created by Joy on 27/04/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import "LoginScreenTableViewController.h"
#import "MBProgressHUD.h"
#import "Defaults.h"

@interface LoginScreenTableViewController ()

@end

@implementation LoginScreenTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgBlank.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    _passwordField.secureTextEntry = YES;

    [self resetSelectedColor];
    
}
//- (void)viewWillAppear:(BOOL)animated {
//[self.navigationController setNavigationBarHidden:NO animated:YES];
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}

- (void)viewDidAppear:(BOOL)animated {
//    if([[NSUserDefaults standardUserDefaults] objectForKey:PARENT_ID] != nil) {
//            
//        NSLog(@"PARENT_ID Key %@",[[NSUserDefaults standardUserDefaults] valueForKey:PARENT_ID]);
//        [self performSegueWithIdentifier:@"goToMain" sender:self];
//    }
    
}
- (void)resetSelectedColor {
    
    UIView *backgroundSelectedCell = [[UIView alloc] init];
    [backgroundSelectedCell setBackgroundColor:[UIColor clearColor]];
    
    for (int section = 0; section < [self.tableView numberOfSections]; section++)
        for (int row = 0; row < [self.tableView numberOfRowsInSection:section]; row++)
        {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellPath];
            
            [cell setSelectedBackgroundView:backgroundSelectedCell];
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)letMeIn:(id)sender {
    
    [self resignAllResponders];
   
    if(_usernameField.text!= nil && ![_usernameField.text isEqualToString:@""]) {
        
        if(_passwordField.text == nil || [[_passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            
            [self showAlertWithMessage:@"Please enter your password." withTitle:@"Password is blank"];
            return;
            
        }
        
        NSURL *url = [NSURL URLWithString:WEB_SERVICE_URL];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:_usernameField.text forKey:@"email"];
        [request setPostValue:_passwordField.text forKey:@"password"];
        [request setPostValue:@"login" forKey:@"tag"];
        [request setDelegate:self];
        [request startAsynchronous];
        
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.labelText = @"Verifying Credentials...";

        
    }
    else {
        
        [self showAlertWithMessage:@"Please enter your Email." withTitle:@"Email is Blank"];
    }
    
}

- (void)requestFinished:(ASIHTTPRequest *)request {

   // NSString *responseString = [request responseString];
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions
                                                                 error:&error];
    if([dictionary valueForKey:@"success"] != nil){
        if([[dictionary valueForKey:@"success"] integerValue] == 1){
            NSLog(@"Authentication Success and Parent ID is %@",[dictionary valueForKey:@"data"]);
            
            [[NSUserDefaults standardUserDefaults] setObject:[dictionary valueForKey:@"data"] forKey:PARENT_ID];
            
            //[self performSegueWithIdentifier:@"goToMain" sender:self];
            [self geBackToPrevious:nil];
        }
        else {
            NSLog(@"Authentication Failed.");
            [self showAlertWithMessage:[dictionary valueForKey:@"message"] withTitle:@"Authentication Failed"];
        }
    }
    
    [self removeHUD];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    //NSError *error = [request error];
    [self showAlertWithMessage:@"Please check your internet connection" withTitle:@"No Data"];
    
    [self removeHUD];
}

-(void)removeHUD {
    
    [HUD removeFromSuperview];
	HUD = nil;
    
}

- (void)showAlertWithMessage:(NSString *)strMsg withTitle:(NSString *)strTitle {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)resignAllResponders {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self resignAllResponders];
}

- (IBAction)geBackToPrevious:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
