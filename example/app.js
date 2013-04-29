var rebtel_sdk = require('com.rebtel.sdk');
Ti.API.info("module is => " + rebtel_sdk);

var client = rebtel_sdk.createClient({
  applicationKey: "<APPLICATION KEY>",
  applicationSecret: "<APPLICATION SECRET>",
  environmentHost: "sdksandbox.rebtel.com",
  userId: "johndoe"
});

var win = Ti.UI.createWindow({
	backgroundColor:'white',
  rebtel_client: client,
});
var label = Ti.UI.createLabel();
win.add(label);
win.open();

client.start();
client.startListeningOnActiveConnection();

// place call ( client must have started first)
// var call = client.call("janedoe")

client.addEventListener('didReceiveIncomingCall',function(event){
    var dialog = Ti.UI.createAlertDialog({
    message: "Incoming call from  " + event.call.remoteUserId,
    ok: 'answer',
    title: 'Rebtel Call'
  });

  dialog.addEventListener('click', function(e){
    event.call.answer();
    // event.call.hangup()
  });
   
  dialog.show();
});

client.addEventListener('onLog', function(e) {
    Titanium.API.log('[' + e.area + '] ' + e.message);
});
