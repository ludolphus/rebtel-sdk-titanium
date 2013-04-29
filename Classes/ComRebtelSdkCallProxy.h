/*
 * Copyright (c) 2012 Rebtel Networks AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import "TiProxy.h"

#import <RebtelSDK/RebtelSDK.h>

@interface ComRebtelSdkCallProxy : TiProxy<REBCallDelegate>

@property(nonatomic, readwrite, strong) id<REBCall> call;

@end
