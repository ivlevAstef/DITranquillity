//
//  UIStoryboard+Swizzling.m
//  DITranquillity
//
//  Created by Nikita Patskov on 27/08/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DINSResolver.h"
#import "NSObject+Swizzling.h"

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

- (__kindof UITableViewCell*)di_dequeueReusableCellWithIdentifier:(NSString*)identifier forIndexPath:(NSIndexPath*)indexPath {
  UITableViewCell* cell = [self di_dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
  [[_DINSResolver getFrom:self] injectInto:cell];
  return cell;
}

  
@end
