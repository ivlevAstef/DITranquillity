//
//  DIStoryboardBase.m
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "DIStoryboardBase.h"

@implementation _DIStoryboardBase

+ (nonnull instancetype)create:(nonnull NSString*)name bundle:(nullable NSBundle*)storyboardBundleOrNil {
  _DIStoryboardBase* storyboard = (_DIStoryboardBase*)[self storyboardWithName:name bundle:storyboardBundleOrNil];
  return storyboard;
}

- (nonnull __kindof UIViewController*)instantiateViewControllerWithIdentifier:(nonnull NSString*)identifier {
  UIViewController* viewController = [super instantiateViewControllerWithIdentifier: identifier];
  
  __typeof(self.resolver) __strong sResolver = self.resolver;
  if (nil == sResolver) {
    return viewController;
  }
  
  return [sResolver resolve:viewController identifier:identifier];
}

@end
