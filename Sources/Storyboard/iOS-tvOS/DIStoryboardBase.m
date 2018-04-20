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
   
+(const void * _Nonnull) RESOLVER_UNIQUE_VC_KEY {
    return &resolverVCKey;
}
  
+(const void * _Nonnull) RESOLVER_UNIQUE_TABLEVIEW_KEY {
  return &resolverViewKey;
}

static NSString *resolverVCKey = @"";
static NSString *resolverViewKey = @"";
    
@end
