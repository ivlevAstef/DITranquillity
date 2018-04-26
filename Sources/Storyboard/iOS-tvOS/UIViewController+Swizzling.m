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

@interface UIViewController (Swizzling)
@end

@implementation UIViewController (Swizzling)
    
+ (void)load {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        [self swizzleOriginalSelector:@selector(loadView)
                     swizzledSelector:@selector(di_loadView)];
    });
}

-(NSResolver *)nsResolver {
    return (NSResolver *)objc_getAssociatedObject(self, [NSResolver getResolverUniqueAssociatedKey]);
}
    
- (void)di_loadView {
  [self di_loadView];
  [self passContainerInto:self.view container:[self nsResolver]];
}

- (void)passContainerInto:(UIView *)view container:(NSResolver *)nsResolver {
  [nsResolver injectInto:view];
  if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]) {
    objc_setAssociatedObject(view, [NSResolver getResolverUniqueAssociatedKey], nsResolver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
  for (UIView *subview in view.subviews) {
    [self passContainerInto: subview container:nsResolver];
  }
}
    
@end
