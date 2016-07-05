//
//  DIStoryboardBase.h
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _DIStoryboardBaseResolver <NSObject>

- (nonnull __kindof UIViewController*)resolve:(nonnull __kindof UIViewController*)viewController;

@end

@interface _DIStoryboardBase : UIStoryboard

+ (nonnull instancetype)create:(nonnull NSString*)name bundle:(nullable NSBundle*)storyboardBundleOrNil;

@property (nonatomic, weak, nullable) id<_DIStoryboardBaseResolver> resolver;

- (nullable __kindof UIViewController*)instantiateInitialViewController;
- (nonnull __kindof UIViewController*)instantiateViewControllerWithIdentifier:(nonnull NSString*)identifier;

@end
