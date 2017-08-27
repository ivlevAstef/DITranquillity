//
//  UIStoryboard+Swizzling.m
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/08/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <DITranquillity/DITranquillity-Swift.h>

@interface UIStoryboard (Swizzling)
@end

@implementation UIStoryboard (Swizzling)

+ (void)load {
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(storyboardWithName:bundle:);
    SEL swizzledSelector = @selector(di_storyboardWithName:bundle:);
    
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
      class_replaceMethod(class, swizzledSelector,
                          method_getImplementation(originalMethod),
                          method_getTypeEncoding(originalMethod));
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod);
    }
  });
}

+ (nonnull instancetype)di_storyboardWithName:(NSString *)name bundle:(nullable NSBundle *)storyboardBundleOrNil {
  if (self == [UIStoryboard class]) {
    return [DIStoryboard createWithName: name bundle: storyboardBundleOrNil];
  } else {
    return [self di_storyboardWithName:name bundle:storyboardBundleOrNil];
  }
}

@end
