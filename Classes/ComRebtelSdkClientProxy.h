/*
 * Copyright (c) 2012 Rebtel Networks AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import "TiProxy.h"

@interface ComRebtelSdkClientProxy : TiProxy {

}

@property(nonatomic, readwrite, copy) NSString* applicationKey;
@property(nonatomic, readwrite, copy) NSString* applicationSecret;
@property(nonatomic, readwrite, copy) NSString* environmentHost;
@property(nonatomic, readwrite, copy) NSString* userId;

@end
