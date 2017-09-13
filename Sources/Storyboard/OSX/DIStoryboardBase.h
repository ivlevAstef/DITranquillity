//
//  DIStoryboardBase.h
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface _DIStoryboardBase : NSStoryboard

+ (nonnull instancetype)_create:(nonnull NSString*)name bundle:(nullable NSBundle*)storyboardBundleOrNil;

@end
