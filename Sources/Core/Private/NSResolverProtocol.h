//
//  NSDIContainerProtocol.h
//  DITranquillity
//
//  Created by Admin on 20/04/2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//


@protocol NSResolverProtocol

+(const void * _Nonnull) getResolverUniqueAssociatedKey;
  
-(void)injectInto:(nonnull id)object;

@end
