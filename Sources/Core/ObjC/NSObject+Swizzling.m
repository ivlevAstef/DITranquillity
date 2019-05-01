//
//  NSObject+Swizzling.m
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/08/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzling)

+ (void)swizzleInstanceOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
  [self swizzleOriginalSelector:originalSelector swizzledSelector:swizzledSelector isClass:NO];
}

+ (void)swizzleClassOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
  [self swizzleOriginalSelector:originalSelector swizzledSelector:swizzledSelector isClass:YES];
}

+ (void)swizzleOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector isClass:(BOOL)isClass {
// IBDesignable incorrect works with swizzling and crash application. But DI don't need - can be disabled swizzling 
#ifdef TARGET_INTERFACE_BUILDER
  return;
#else
  Class class;
  Method originalMethod;
  Method swizzledMethod;

  if (isClass) {
    class = object_getClass((id)self);
    originalMethod = class_getClassMethod(class, originalSelector);
    swizzledMethod = class_getClassMethod(class, swizzledSelector);
  } else {
    class = [self class];
    originalMethod = class_getInstanceMethod(class, originalSelector);
    swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
  }

  BOOL didAddMethod =
  class_addMethod(class,
                  originalSelector,
                  method_getImplementation(swizzledMethod),
                  method_getTypeEncoding(swizzledMethod));
  
  if (didAddMethod) {
    class_replaceMethod(class,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
#endif  
}

@end
