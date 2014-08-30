//
//  JGLoginViewController.h
//  All Curb Appeal
//
//  Created by Joy on 26/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGPayViewController.h"

@interface JGLoginViewController : UIViewController <UITextFieldDelegate,MBProgressHUDDelegate,NSURLConnectionDelegate> {
    MBProgressHUD *HUD;
    NSMutableData* httpResponse;
}
@property (nonatomic,strong) NSString *userID;

@property (nonatomic,weak) IBOutlet UITextField *txtUserName;
@property (nonatomic,weak) IBOutlet UITextField *txtPassword;

@property (nonatomic,weak) IBOutlet JGButton *loginBtn;
- (IBAction)loginAction:(id)sender;

@end
