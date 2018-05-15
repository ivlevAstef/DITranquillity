//
//  UIStoryboard+Swizzling.m
//  DITranquillity
//
//  Created by Nikita Patskov on 27/08/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#import "UIView+Swizzling.h"
#import "NSObject+Swizzling.h"

@interface UIViewController (Swizzling)
@end

@implementation UIViewController (Swizzling)

+ (void)load {
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    [self swizzleInstanceOriginalSelector:@selector(loadView)
                         swizzledSelector:@selector(di_loadView)];
  });
}

- (void)di_loadView {
  [self di_loadView];
  [self.view safePassResolver:[_DINSResolver getFrom:self]];
}


@end
