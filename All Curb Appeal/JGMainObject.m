//
//  JGMainObject.m
//  All Curb Appeal
//
//  Created by Joy on 30/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import "JGMainObject.h"

@implementation JGMainObject
+ (id)sharedInstance {
    static JGMainObject *sharedMyInstance = nil;
    @synchronized(self) {
        if (sharedMyInstance == nil)
            sharedMyInstance = [[self alloc] init];
    }
    return sharedMyInstance;
}


@end
