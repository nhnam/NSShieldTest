//
//  NSArray+IndexHelper.m
//  C_POS
//
//  Created by Tomohisa Takaoka on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArray+IndexHelper.h"

@implementation NSArray (IndexHelper)

- (id)objectAtIndexedSubscript:(NSUInteger)index {
   return [self safeObjectForIndex:index];
}

- (id)safeObjectForIndex:(NSUInteger)index {
   if ( index >= self.count) {
      return nil;
   }
   id object = [self objectAtIndex:index];
   if ([object isKindOfClass:[NSNull class]] || !object) return nil;
   else return object;
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)idx {
   if ([object isKindOfClass:[NSNull class]] || !object) {
      return;
   } else {
      self[idx] = object;
   }
}

- (id)safeObjectAtIndex:(NSUInteger)index {
   return self[index];
}
@end
