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

@interface UITableView (Swizzling)
@end

@implementation UITableView (Swizzling)
  
+ (void)load {
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    [self swizzleOriginalSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)
                 swizzledSelector:@selector(di_dequeueReusableCellWithIdentifier:forIndexPath:)];
  });
}
  
  
+ (void)swizzleOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
  
  Class class = [self class];
  
  Method originalMethod = class_getInstanceMethod(class, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
  
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
}
  

-(NSResolver *)nsResolver {
  return (NSResolver *)objc_getAssociatedObject(self, [NSResolver getResolverUniqueAssociatedKey]);
}


- (__kindof UITableViewCell *)di_dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self di_dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
  [[self nsResolver] injectInto: cell];
  return cell;
}

  
@end
