//
//  NSDICT.m
//  Ring
//
//  Created by Nguyen Hoang Nam on 25/5/16.
//  Copyright © 2016 Medpats Global Pte. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 ---------------------------------------------------------------------------------------
 Obj-C Literal Dictionary Syntax - Multiple reasons for allowing nil values
 Radar 19747372
 ---------------------------------------------------------------------------------------
 
 The obj-c literal syntax for dictionaries does not allow nils.
 
 @{key : nil};  // Exception (and compiler error)
 
 
 This makes it impossible to conveniently create a dictionary where a value may more may
 not be nil.
 
 - (NSDictionary *)doSomething
 {
 NSData * data = ....;
 NSString * metadata1 = ...;
 NSString * metadata2 = ...;
 
 return @{
 @"data" : data,
 @"metadata1" : metadata1,
 @"metadata2" : metadata2
 };
 }
 
 
 If data, metadata1, or metadata2 is nil, there'll be a runtime exception. Thus we have
 to rewrite it, the most brief form of which being:
 
 
 - (NSDictionary *)doSomething
 {
 NSData * data = ....;
 NSString * metadata1 = ...;
 NSString * metadata2 = ...;
 
 NSMutableDictionary * mdict = [NSMutableDictionary dictionary];
 if (data)      [mdict setObject:data forKey:@"data"];
 if (metadata1) [mdict setObject:metadata1 forKey:@"metadata1"];
 if (metadata2) [mdict setObject:metadata2 forKey:@"metadata2"];
 return [mdict copy];
 }
 
 
 The above case happens **frequently**, which alone makes it really strange that the
 Obj-C literal syntax does not allow nil values.
 
 
 
 
 Another case where accepting nil values would be useful, is in dynamically excluding a
 k/v pair based on some flag, while maintaining code brevity. For instance:
 
 
 - (NSDictionary *)settingsForSomethingWithOptions:(BOOL)option
 {
 Foo * foo = ...;
 
 NSMutableDictionary * mdict = [NSMutableDictionary dictionary];
 [mdict setObject:foo.something forKey:@"something"];
 [mdict setObject:foo.something2 forKey:@"something2"];
 [mdict setObject:foo.something3 forKey:@"something3"];
 [mdict setObject:foo.something4 forKey:@"something4"];
 [mdict setObject:whoKnows forKey:@"whatever"];
 
 if (option) {
 [mdict setObject:foo.blah forKey:@"blah"];
 }
 
 return [mdict copy];
 }
 
 
 The above could be rewritten far more briefly if the literal syntax supported accepting
 nil values:
 
 - (NSDictionary *)settingsForSomethingWithOptions:(BOOL)option
 {
 Foo * foo = ...;
 return @{
 @"something" : foo.something,
 @"something2" : foo.something2,
 @"something3" : foo.something3,
 @"something4" : foo.something4,
 @"whatever" : whoKnows,
 @"blah" : (option ? foo.blah : nil)
 };
 }
 
 
 
 This is less code, more flexible, and easier to understand.
 
 
 There's an argument to be made that doing @{key : nil}.allKeys logically must be
 expected to be @[key], but we're all adults here, and to anyone with a brain, it'd be
 easily understood that this wouldn't be the case, as the dictionary simply wouldn't
 have any entry for the key.
 
 
 Why does the Obj-C literal not accept nil values? We all know what it would mean, so
 why doesn't it work that way?
 
 Changing it now wouldn't break any existing code because all previously written valid
 code is still valid. The only things that would change are:
 
 1) Exceptions on nil values are no longer thrown (and developers all over the world
 would rejoice).
 2) A likely negligible performance impact from having to test if the value is nil.
 3) To implement this with maximum performance, either:
 a) NSDictionary would need a new method akin to initWithObjects:forKeys:count:
 that accepted nil values,. The impact of having a new method would mean
 support for nil values would be limited to applications with a deployment
 target that has an implementation for it.
 b) OR, if the above method did not exist, the compiler would provide a built-in
 implementation for it.
 
 
 These are all reasonable things, and the improvement in actually being able to use the
 literal syntax for almost every purpose, would well make up for it.
 
 Furthermore, I still don't understand why there isn't support for a mutable variants:
 @m{}  @m[]
 
 
 
 
 
 =======================================================================================
 */

// As a workaround, here's one solution. It's a lot of code, but it's performant, at
// only ~10% slower than a literal when using <= 16 kv pairs, and 20% when using more
// than 16. It's 3x *faster* than using a mutable dictionary.

#import "NSDICT.h"
