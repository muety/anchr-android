package io.muetsch.anchrandroid;

import android.content.Intent;
import android.os.Bundle;

import java.util.HashMap;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private Map<String, String> sharedData = new HashMap();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        Intent intent = getIntent();
        String action = intent.getAction();
        String type = intent.getType();

        if (Intent.ACTION_SEND.equals(action) && type != null) {
            if ("text/plain".equals(type)) {
                handleSendText(intent); // Handle text being sent
            }
        }

        new MethodChannel(getFlutterView(), "app.channel.shared.data").setMethodCallHandler(
            new MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                    if (call.method.contentEquals("getSharedData")) {
                        result.success(sharedData);
                        sharedData.clear();
                    }
                }
            }
        );
    }

    void handleSendText(Intent intent) {
        sharedData.put("subject", intent.getStringExtra(Intent.EXTRA_SUBJECT));
        sharedData.put("text", intent.getStringExtra(Intent.EXTRA_TEXT));
    }
}
