//
//  DIStoryboardBase.h
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#ifdef __DITRANQUILLITY_STORYBOARD__

#import <UIKit/UIKit.h>

@protocol _DIStoryboardBaseResolver <NSObject>

- (nonnull __kindof UIViewController*)resolve:(nonnull __kindof UIViewController*)viewController identifier:(nonnull NSString*)String;

@end

@interface _DIStoryboardBase : UIStoryboard

+ (nonnull instancetype)create:(nonnull NSString*)name bundle:(nullable NSBundle*)storyboardBundleOrNil;

@property (nonatomic, strong, nullable) id<_DIStoryboardBaseResolver> resolver;

- (nonnull __kindof UIViewController*)instantiateViewControllerWithIdentifier:(nonnull NSString*)identifier;

@end

#endif