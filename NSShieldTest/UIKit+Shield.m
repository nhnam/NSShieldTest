//
//  NSObject+Shield.m
//  NSShieldTest
//
//  Created by Nguyen Hoang Nam on 5/6/16.
//  Copyright © 2016 Alan Nguyen. All rights reserved.
//

#import "UIKit+Shield.h"
#import <objc/runtime.h>

@implementation UIView(Shield)
- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [@"" methodSignatureForSelector:selector];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    
    if ([@"" respondsToSelector:aSelector])
        [anInvocation invokeWithTarget:@""];
    else
        [self doesNotRecognizeSelector:aSelector];
}
@end


@implementation UIViewController(Shield)
- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [@"" methodSignatureForSelector:selector];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    
    if ([@"" respondsToSelector:aSelector])
        [anInvocation invokeWithTarget:@""];
    else
        [self doesNotRecognizeSelector:aSelector];
}
@end
