//
//  NSObject+Swizzling.h
//  DITranquillity
//
//  Created by Alexander Ivlev on 26.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

+ (void)swizzleInstanceOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
+ (void)swizzleClassOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
