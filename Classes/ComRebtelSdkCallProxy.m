/*
 * Copyright (c) 2012 Rebtel Networks AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import "ComRebtelSdkCallProxy.h"

@implementation ComRebtelSdkCallProxy

#pragma mark - REBCallDelegate

- (void)callEnded:(id<REBCall>)call {
  [self fireEvent:@"callEnded"];
}

- (void)callEstablished:(id<REBCall>)call {
  [self fireEvent:@"callEstablished"];
}

- (void)callAnswered:(id<REBCall>)call {
  [self fireEvent:@"callAnswered"];
}

- (void)callReceivedOnRemoteEnd:(id<REBCall>)call {
  [self fireEvent:@"callReceivedOnRemoteEnd"];
}

- (void)call:(id<REBCall>)call
    shouldSendPushNotificationPayload:(NSString *)payload
                                   to:(NSArray *)devicePushNotificationData {
  id event = @{ @"payload" : payload, @"to" : devicePushNotificationData };
  [self fireEvent:@"shouldSendPushNotificationPayload" withObject:event];
}

#pragma mark - Titanium proxy methods

- (NSString *)callId {
  return [self.call callId];
}

- (NSString *)remoteUserId {
  return [[self call] remoteUserId];
}

- (id)direction {
  return [NSNumber numberWithInteger:[[self call] direction]];
}

- (id)state {
  return [NSNumber numberWithInteger:[[self call] state]];
}

- (void)answer:(id)unused {
  [self.call answer];
}

- (void)hangup:(id)unused {
  [self.call hangup];
}

- (void)setUserInfo:(id)value {
  [self.call setUserInfo:value];
  [self replaceValue:value forKey:@"userInfo" notification:NO];
}

@end
