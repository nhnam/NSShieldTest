//
//  NSArray+IndexHelper.h
//  C_POS
//
//  Created by Tomohisa Takaoka on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (IndexHelper)
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx; // setter
- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (id)safeObjectAtIndex:(NSUInteger)index;
@end
