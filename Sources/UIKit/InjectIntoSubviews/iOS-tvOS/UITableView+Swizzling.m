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
#import "UIView+Swizzling.h"

@interface UITableView (Swizzling)
@end

@implementation UITableView (Swizzling)
  
+ (void)load {
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    [self swizzleInstanceOriginalSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)
                         swizzledSelector:@selector(di_dequeueReusableCellWithIdentifier:forIndexPath:)];

    [self swizzleInstanceOriginalSelector:@selector(dequeueReusableCellWithIdentifier:)
                         swizzledSelector:@selector(di_dequeueReusableCellWithIdentifier:)];

    [self swizzleInstanceOriginalSelector:@selector(dequeueReusableHeaderFooterViewWithIdentifier:)
                         swizzledSelector:@selector(di_dequeueReusableHeaderFooterViewWithIdentifier:)];
  });
}

- (nullable __kindof UITableViewCell*)di_dequeueReusableCellWithIdentifier:(NSString*)identifier {
  UITableViewCell* cell = [self di_dequeueReusableCellWithIdentifier:identifier];
  [cell safePassResolver:[_DINSResolver getFrom:self]];
  return cell;
}

- (nullable __kindof UITableViewCell*)di_dequeueReusableCellWithIdentifier:(NSString*)identifier forIndexPath:(NSIndexPath*)indexPath {
  UITableViewCell* cell = [self di_dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
  [cell safePassResolver:[_DINSResolver getFrom:self]];
  return cell;
}

- (nullable __kindof UITableViewHeaderFooterView*)di_dequeueReusableHeaderFooterViewWithIdentifier:(NSString*)identifier {
  UITableViewHeaderFooterView* view = [self di_dequeueReusableHeaderFooterViewWithIdentifier:identifier];
  [view safePassResolver:[_DINSResolver getFrom:self]];
  return view;
}
  
@end
