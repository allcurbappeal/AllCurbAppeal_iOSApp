//
//  JGResetViewController.h
//  All Curb Appeal
//
//  Created by Joy on 31/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGResetViewController : UIViewController <UITextFieldDelegate,NSURLConnectionDelegate> {
    MBProgressHUD *HUD;
    NSMutableData* httpResponse;
}
@property (nonatomic,strong) IBOutlet UITextField *recovery;
@end
