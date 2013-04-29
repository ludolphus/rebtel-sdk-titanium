# Appcelerator Titanium native module for Rebtel SDK

A Titanium module for the Rebtel iOS SDK, which lets you integrate
voice calling (VoIP) functionality in your application.

See [developer.rebtel.com](http://developer.rebtel.com) for more
information about the Rebtel SDK and detailed documentation of its
functionality.

# IMPORTANT

Note that this titanium module is still at a pre-1.0 state, and neither a part of the official Rebtel SDK. The javascript bindings are not covering 100% of the native iOS SDK, and there may be issues and bugs.

# Building the module

Simply run `./build.py`.

As part of the build process, it will automatically download the
Rebtel SDK package and place the iOS Framework in vendor/RebtelSDK,
and lib/libRebtelSDK.a. The reason a copy of the library which usually
resides within the .framework bundle is copied to lib/libRebtelSDK.a
is because it needs to be statically linked in to the Titanium module
itself, thus required to be a static library and not specified as a
linked framework.

Once the Rebtel SDK framework/library is in place, the complete
Titanium module will be built and packaged as
com.rebtel.sdk-iphone-[VERSION].zip.

# Usage

Get your Application Key and Application Secret at [developer.rebtel.com](http://developer.rebtel.com).

## Starting the Rebtel client

    var rebtel_sdk = require('com.rebtel.sdk');
    
    var client = rebtel_sdk.createClient({
        applicationKey: "<APPLICATION KEY>",
        applicationSecret: "<APPLICATION SECRET>",
        environmentHost: "sdksandbox.rebtel.com",
        userId: "johndoe"
    });
    
    client.start();
    client.startListeningOnActiveConnection(); 
    

## Place outgoing call
    
    var call = client.call("janedoe")

## Receive incoming calls

    client.addEventListener('didReceiveIncomingCall',function(event){
        var dialog = Ti.UI.createAlertDialog({
            message: "Incoming call from  " + event.call.remoteUserId,
            ok: 'answer',
            title: 'Incoming Rebtel Call'
        });
        
        dialog.addEventListener('click', function(e){
            event.call.answer()
        });
   
        dialog.show();
    });

# Using iOS background modes

The Rebtel SDK requires you to use the _UIBackgroundModes_ `audio` and `voip`. 

Update your `ti.app` as follows:

    <iphone>
        <backgroundModes>
          <mode>voip</mode>
          <mode>audio</mode>
        </backgroundModes>          
    </iphone>
    
    
# Rebtel Titanium Module API

## com.rebtel.sdk (the module interface)

The module entry point maps to [RebtelSDK](http://developer.rebtel.com/docs/ios/referenceguide/Classes/RebtelSDK.html).

`createClient`

## com.rebtel.sdk.client

_client_ maps to [REBClient](http://developer.rebtel.com/docs/ios/referenceguide/Protocols/REBClient.html).

### Methods

`call(userId:string)`

### Events:

These events map to [REBClientDelegate](http://developer.rebtel.com/docs/ios/referenceguide/Protocols/REBClientDelegate.html).

`didReceiveIncomingCall`, on which a property `call` is available on the event object.  
`clientDidStart`  
`clientDidStop`  
`clientDidFail`, on which a property `error` is available on the event object.  
`onLog`


## com.rebtel.sdk.call

_call_ maps to [REBCall](http://developer.rebtel.com/docs/ios/referenceguide/Protocols/REBCall.html)

### Methods

`answer`  
`hangup`

### Properties:

`remoteUserId:string`  
`direction:int`  
`state:int`  

### Events:

These events map to [REBCallDelegate](http://developer.rebtel.com/docs/ios/referenceguide/Protocols/REBCallDelegate.html).

`callReceivedOnRemoteEnd`  
`callAnswered`  
`callEstablished`  
`callEnded`


# Contributing

By contributing code to the the Rebtel SDK Titanium module project in
any form, including sending a pull request via Github, a code fragment
or patch via private email or public discussion groups, you agree to
release your code under the terms of the BSD license that you can find
in the LICENCE file that can be found in the root of this repository
(https://github.com/cahlbin/rebtel-sdk-titanium)


