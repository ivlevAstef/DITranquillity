//
//  UIStoryboard+Swizzling.m
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/08/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <DITranquillity/DITranquillity-Swift.h>

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
    
    
+ (void)swizzleOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
    
-(StoryboardResolver *)storyboardResolver {
    return (StoryboardResolver *)objc_getAssociatedObject(self, [_DIStoryboardBase RESOLVER_UNIQUE_VC_KEY]);
}
    
- (void)di_loadView {
    [self di_loadView];
    [self.storyboardResolver injectInto: [self viewIfLoaded]];
}
    
@end
