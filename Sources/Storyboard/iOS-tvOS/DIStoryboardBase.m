//
//  DIStoryboardBase.m
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "DIStoryboardBase.h"

@implementation _DIStoryboardBase

+ (nonnull instancetype)_create:(nonnull NSString*)name bundle:(nullable NSBundle*)storyboardBundleOrNil {
  return (id)[self storyboardWithName:name bundle:storyboardBundleOrNil];
}
    
@end
