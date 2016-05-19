//
//  LoginViewController.m
//  HereIAm
//
//  Created by Nav Pillai on 5/1/16.
//  Copyright © 2016 Nav Pillai. All rights reserved.
//

#import "LoginViewController.h"
#import "GoogleMapViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField; //textField outlet
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.placeholder = @"Enter a message"; //instructs user on what to enter
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"loggedInSegue"]){
        //gets GoogleMapViewController from TabBar and then UINavigationController
        UITabBarController* tb = (UITabBarController *)[segue destinationViewController];
        UINavigationController* nc = (UINavigationController *)[tb.viewControllers objectAtIndex:0];
        GoogleMapViewController *vc = (GoogleMapViewController *)[nc topViewController];

        //sets postDescription property to user-entered text
        vc.postDescription = self.textField.text;
        NSLog(@"%@", vc.postDescription);
    }
}

//dismisses keyboard
- (void) touchesBegan: (NSSet *)touches
            withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.textField isFirstResponder] &&
        [touch view] != self.textField) {
        [self.textField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

@end