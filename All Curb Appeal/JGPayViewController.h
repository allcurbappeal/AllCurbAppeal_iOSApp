//
//  JGPayViewController.h
//  All Curb Appeal
//
//  Created by Joy on 30/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+TCUtils.h"
#import "ActionSheetPicker.h"

@interface JGPayViewController : UITableViewController<NSURLConnectionDelegate> {
    
    MBProgressHUD *HUD;
    NSMutableData* httpResponse;
    JGMainObject *mObj;
    NSArray *cardArr;
    NSArray *monthExpire;
    NSArray *yearExpire;
}
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic,strong) NSString *userID;
@property (nonatomic) NSInteger month;
@property (nonatomic,strong) IBOutlet UITextField *cardNumber;
@property (nonatomic,strong) IBOutlet UITextField *cvv;
@property (nonatomic,strong) IBOutlet UITextField *monthExpiry,*yearExpiry;
@property (nonatomic,strong) IBOutlet UILabel *cardType;

@end
