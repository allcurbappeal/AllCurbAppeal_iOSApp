//
//  JGMainObject.h
//  All Curb Appeal
//
//  Created by Joy on 30/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGMainObject : NSObject
+ (id)sharedInstance;

//0
@property (nonatomic,strong) NSString *cardType;
@property (nonatomic,strong) NSString *cardNumber;
@property (nonatomic)        NSInteger expirationMonth;
@property (nonatomic)        NSInteger expirationYear;
@property (nonatomic,strong) NSString *cvv;
//1
@property (nonatomic,strong) UIImage *firstImage;
//2
@property (nonatomic,strong) NSString *ticketNO;
//3
@property (nonatomic)        NSInteger cat_id;
//4
@property (nonatomic,strong) NSString *comment;
//5
@property (nonatomic,strong) UIImage *secondImage;
@property (nonatomic,strong) UIImage *thirdImage;
@property (nonatomic,strong) UIImage *fourthImage;

@end
