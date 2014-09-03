//
//  JGViewController.m
//  All Curb Appeal
//
//  Created by Joy on 24/08/14.
//  Copyright (c) 2014 Joy. All rights reserved.
//

#import "JGViewController.h"

@interface JGViewController ()

@end

@implementation JGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Customize UI


#pragma mark - UnWind 

- (IBAction)unwindToMain:(UIStoryboardSegue *)unwindSegue
{
}


- (IBAction)openLinks:(id)sender {
    
    switch ([sender tag]) {
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com"]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com"]];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
            break;
        case 4:
            //[self presentViewController:vc2 animated:YES completion:nil];
            [self performSegueWithIdentifier:@"legal" sender:self];
            break;
        case 5:
            [self performSegueWithIdentifier:@"privacy" sender:self];
            break;
            
        default:
            break;
    }
    
}

@end
