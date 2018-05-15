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

@interface UICollectionView (Swizzling)
@end

@implementation UICollectionView (Swizzling)

+ (void)load {
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    [self swizzleInstanceOriginalSelector:@selector(dequeueReusableCellWithReuseIdentifier:forIndexPath:)
                         swizzledSelector:@selector(di_dequeueReusableCellWithReuseIdentifier:forIndexPath:)];

    [self swizzleInstanceOriginalSelector:@selector(dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:)
                         swizzledSelector:@selector(di_dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:)];
  });
}

- (__kindof UICollectionViewCell*)di_dequeueReusableCellWithReuseIdentifier:(NSString*)identifier forIndexPath:(NSIndexPath*)indexPath {
  UICollectionViewCell* cell = [self di_dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  [cell safePassResolver:[_DINSResolver getFrom:self]];
  return cell;
}

- (__kindof UICollectionReusableView*)di_dequeueReusableSupplementaryViewOfKind:(NSString*)elementKind withReuseIdentifier:(NSString*)identifier forIndexPath:(NSIndexPath*)indexPath {
  UICollectionReusableView* view = [self di_dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier forIndexPath:indexPath];
  [view safePassResolver:[_DINSResolver getFrom:self]];
  return view;
}

@end
