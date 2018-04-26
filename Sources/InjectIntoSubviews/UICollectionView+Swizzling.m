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

@interface UICollectionView (Swizzling)
@end

@implementation UICollectionView (Swizzling)

+ (void)load {
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    [self swizzleOriginalSelector:@selector(dequeueReusableCellWithReuseIdentifier:forIndexPath:)
                 swizzledSelector:@selector(di_dequeueReusableCellWithReuseIdentifier:forIndexPath:)];
  });
}

- (__kindof UICollectionViewCell*)di_dequeueReusableCellWithReuseIdentifier:(NSString*)identifier forIndexPath:(NSIndexPath*)indexPath {
  UICollectionViewCell* cell = [self di_dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

  [[_DINSResolver getFrom:self] injectInto:cell];
  return cell;
}


@end
