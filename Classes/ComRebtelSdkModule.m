/**
 * Copyright (c) 2012 Rebtel Networks AB. All rights reserved.
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComRebtelSdkModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import <RebtelSDK/RebtelSDK.h>
#import "ComRebtelSdkClientProxy.h"

@implementation ComRebtelSdkModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"cff1b70a-3936-48d7-944b-5f44f08380bf";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.rebtel.sdk";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

@end
