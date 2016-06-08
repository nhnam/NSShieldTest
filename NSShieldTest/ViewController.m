//
//  ViewController.m
//  NSShieldTest
//
//  Created by Nguyen Hoang Nam on 5/6/16.
//  Copyright © 2016 Alan Nguyen. All rights reserved.
//

#import "ViewController.h"
#import <NSShield/UIKit+Shield.h>

@protocol ViewControllerProtocol <NSObject>
-(void)sendAFakeMessage;
@end

@interface ViewController ()<ViewControllerProtocol>

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.
    [self sendAFakeMessage];

    //2.
    [self performSelector:@selector(sendAFakeMessage)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
