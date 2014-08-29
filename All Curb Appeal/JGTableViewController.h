//
//  JGTableViewController.h
//  All Curb Appeal
//
//  Created by Joy on 29/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryPicker.h"
@class RadioButton;

@interface JGTableViewController : UITableViewController <CountryPickerDelegate,UITextFieldDelegate,NSURLConnectionDelegate,UIActionSheetDelegate> {
    
    MBProgressHUD *HUD;
    NSMutableData* httpResponse;
}

@property (nonatomic, strong) IBOutlet RadioButton* maleButton;

@property (nonatomic,weak) IBOutlet UITextField *fname;
@property (nonatomic,weak) IBOutlet UITextField *lname;
@property (nonatomic,weak) IBOutlet UITextField *username;
@property (nonatomic,weak) IBOutlet UITextField *email;
@property (nonatomic,weak) IBOutlet UITextField *password;
@property (nonatomic,weak) IBOutlet UITextField *confirmPassword;
@property (nonatomic,weak) IBOutlet UITextField *phone;
@property (nonatomic,weak) IBOutlet UITextField *zip;

@property (nonatomic,weak) IBOutlet UITextField *country;
@property (nonatomic,weak) IBOutlet UITextField *birthday;

@property (nonatomic,strong) NSString *gender;

@property (nonatomic,strong) CountryPicker *ctPicker;
@property (nonatomic,strong) UIDatePicker *dobPicker;
@end
