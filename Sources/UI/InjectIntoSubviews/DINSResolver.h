//
//  DINSResolver.h
//  DITranquillity
//
//  Created by Alexander Ivlev on 26.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _DINSResolver: NSObject

- (void)injectInto:(nonnull id)obj;

+ (nullable _DINSResolver*)getFrom:(nonnull id)obj;
- (void)setTo:(nonnull id)obj;

@end
