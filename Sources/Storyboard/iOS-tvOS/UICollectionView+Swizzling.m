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

-(NSResolver *)nsResolver {
    return (NSResolver *)objc_getAssociatedObject(self, [NSResolver getResolverUniqueAssociatedKey]);
}


- (__kindof UICollectionViewCell *)di_dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [self di_dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  [[self nsResolver] injectInto:cell];
  return cell;
}


@end
