//
//  UIStoryboard+Swizzling.m
//  DITranquillity
//
//  Created by Nikita Patskov on 27/08/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <DITranquillity/DITranquillity-Swift.h>
#import "NSObject+Swizzling.m"

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
  
-(NSResolver *)nsResolver {
  return (NSResolver *)objc_getAssociatedObject(self, [NSResolver getResolverUniqueAssociatedKey]);
}


- (__kindof UITableViewCell *)di_dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self di_dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
  [[self nsResolver] injectInto: cell];
  return cell;
}

  
@end
