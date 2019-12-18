//
//  DITranquillity.h
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

@import Foundation;

FOUNDATION_EXPORT double DITranquillityVersionNumber;
FOUNDATION_EXPORT const unsigned char DITranquillityVersionString[];

#if TARGET_OS_IOS || TARGET_OS_TV || (!TARGET_OS_WATCH && TARGET_OS_MAC)

#if __has_include(<DITranquillity/DIStoryboardBase.h>)
#import <DITranquillity/DIStoryboardBase.h>
#elif __has_include("DIStoryboardBase.h")
#import "DIStoryboardBase.h"
#endif

#if __has_include(<DITranquillity/DINSResolver.h>)
#import <DITranquillity/DINSResolver.h>
#elif __has_include("DINSResolver.h")
#import "DINSResolver.h"
#endif

#endif
