/*
 * Copyright (c) 2012 Rebtel Networks AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import "ComRebtelSdkClientProxy.h"
#import "ComRebtelSdkCallProxy.h"

#import <RebtelSDK/RebtelSDK.h>

@interface ComRebtelSdkClientProxy ()<REBClientDelegate>

@property(nonatomic, readwrite, strong) id<REBClient> client;

@end

@implementation ComRebtelSdkClientProxy

// Lazy intialization of the underlying REBClient is used because that let us
// utilize the Titanium factory method conventions and create an instance of
// ComRebtelSdkClientProxy with the corresponding js method 'createClient'.

- (id<REBClient>)client {
  if (!_client) {
    if ([self.applicationSecret length] > 0) {
      _client = [RebtelSDK clientWithApplicationKey:self.applicationKey
                                  applicationSecret:self.applicationSecret
                                    environmentHost:self.environmentHost
                                             userId:self.userId];
    } else {
      _client = [RebtelSDK clientWithApplicationKey:self.applicationKey
                                    environmentHost:self.environmentHost
                                             userId:self.userId];
    }
    [_client setDelegate:self];
  }
  return _client;
}

#pragma mark - REBClientDelegate

- (void)client:(id<REBClient>)client didReceiveIncomingCall:(id<REBCall>)call {
  ComRebtelSdkCallProxy* proxy = [[ComRebtelSdkCallProxy alloc] init];
  proxy.call = call;
  call.delegate = proxy;
  [self fireEvent:@"didReceiveIncomingCall" withObject:@{ @"call" : proxy }];
}

- (void)clientDidStart:(id<REBClient>)client {
  [self fireEvent:@"clientDidStart"];
}

- (void)clientDidStop:(id<REBClient>)client {
  [self fireEvent:@"clientDidStop"];
}

- (void)clientDidFail:(id<REBClient>)client error:(NSError*)error {
  [self fireEvent:@"clientDidFail"
       withObject:@{ @"error" : [error localizedDescription] }];
}

- (void)client:(id<REBClient>)client
    logMessage:(NSString*)message
          area:(NSString*)area
      severity:(REBLogSeverity)severity
     timestamp:(NSDate*)timestamp {
  [self fireEvent:@"onLog"
       withObject:@{ @"message" : message, @"area" : area,
                     @"severity" : [NSNumber numberWithInt:severity],
                     @"timestamp" : timestamp }];
}

#pragma mark - Titanium proxy methods

- (void)start:(id)unused {
  [self.client start];
}

- (void)startListeningOnActiveConnection:(id)unused {
  [self.client startListeningOnActiveConnection];
}

- (void)stop:(id)unused {
  [self.client stop];
}

- (void)stopListeningOnActiveConnection:(id)unused {
  [self.client stopListeningOnActiveConnection];
}

- (id)call:(id)args {
  if (!args || [args length] < 1) {
    [NSException raise:NSInvalidArgumentException
                format:@"userId must be provided"];
    return nil;
  }
  NSString* userId = args[0];
  id<REBCall> call = [self.client callUserWithId:userId];
  ComRebtelSdkCallProxy* proxy = [[ComRebtelSdkCallProxy alloc] init];
  proxy.call = call;
  call.delegate = proxy;
  return proxy;
}

@end
