//
//  UIView+Swizzling.m
//  DITranquillity
//
//  Created by Alexander Ivlev on 26.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

#import "UIView+Swizzling.h"
#import "NSObject+Swizzling.h"

@implementation UIView (Swizzling)

+ (void)load {
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    [self swizzleInstanceOriginalSelector:@selector(didAddSubview:)
                         swizzledSelector:@selector(di_didAddSubview:)];
  });
}

- (void)di_didAddSubview:(UIView*)view {
  [self di_didAddSubview:view];

  [view safePassResolver:[_DINSResolver getFrom:self]];
}

- (void)safePassResolver:(_DINSResolver*)resolver {
  if (nil != resolver) {
    [self passResolver:resolver];
  }
}

- (void)passResolver:(_DINSResolver*)resolver {
  // fix double inject
  if (nil != [_DINSResolver getFrom:self]) {
    return;
  }

  [resolver setTo:self];
  [resolver injectInto:self];

  for (UIView* subview in self.subviews) {
    [subview passResolver:resolver];
  }
}

@end

