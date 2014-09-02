//
//  JGPostViewController.h
//  All Curb Appeal
//
//  Created by Joy on 30/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ActionSheetPicker.h"
@interface JGPostViewController : UITableViewController <UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,NSURLConnectionDelegate> {
    
    MBProgressHUD *HUD;
    NSMutableData* httpResponse;
    JGMainObject *mObj;
    NSArray *catArr;
    NSArray *catIds;
    
}
@property (nonatomic) BOOL isCat;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic) NSInteger imgIndex;
@property (nonatomic,strong) NSString  *catID;
@property (nonatomic,strong) IBOutlet UIImageView *img1,*img2,*img3,*img4;
@property (nonatomic,strong) IBOutlet UITextField *ticketNo,*reason;
@property (nonatomic,strong) IBOutlet UITextView *comment;
@end
