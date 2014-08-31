//
//  JGTableViewController.h
//  All Curb Appeal
//
//  Created by Joy on 29/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGPayViewController.h"
#import "NSDate+TCUtils.h"
#import "ActionSheetPicker.h"
@class RadioButton;
@class AbstractActionSheetPicker;

@interface JGTableViewController : UITableViewController <UITextFieldDelegate,NSURLConnectionDelegate,UIActionSheetDelegate> {
    
    MBProgressHUD *HUD;
    NSMutableData* httpResponse;
    BOOL bIsCountry;
    NSMutableArray *arrCountry;
}
@property (nonatomic,strong) NSDate *selectedDate;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property (nonatomic, assign) NSInteger selectedIndex;


@property (nonatomic,strong) NSString *userID;

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

@property (nonatomic,strong) UIDatePicker *dobPicker;
@end
