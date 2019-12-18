//
//  DIStoryboardBase.h
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _DIStoryboardBase : UIStoryboard

+ (nonnull instancetype)_create:(nonnull NSString*)name bundle:(nullable NSBundle*)storyboardBundleOrNil;

@end
