//
//  DIStoryboardBase.h
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol _DIStoryboardBaseResolver <NSObject>

- (nonnull id)resolve:(nonnull id)viewController identifier:(nonnull NSString*)String;

@end

@interface _DIStoryboardBase : NSStoryboard

+ (nonnull instancetype)create:(nonnull NSString*)name bundle:(nullable NSBundle*)storyboardBundleOrNil;

@property (nonatomic, strong, nullable) id<_DIStoryboardBaseResolver> resolver;

@end
