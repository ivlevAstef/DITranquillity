//
//  DINSResolver.m
//  DITranquillity
//
//  Created by Alexander Ivlev on 26.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

#import "DINSResolver.h"
#import <objc/runtime.h>

static char kAssociatedObjectKey = '_';

@implementation _DINSResolver

- (void)injectInto:(nonnull id)obj {
  assert(false && "Override");
}

+ (nullable _DINSResolver*)getFrom:(nonnull id)obj {
  return objc_getAssociatedObject(obj, &kAssociatedObjectKey);
}

- (void)setTo:(nonnull id)obj {
  objc_setAssociatedObject(obj, &kAssociatedObjectKey, self, OBJC_ASSOCIATION_RETAIN);
}


@end
