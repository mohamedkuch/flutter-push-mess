package com.example.push_app;


import android.content.Context;
import android.content.SharedPreferences;

import org.json.JSONException;
import org.json.JSONObject;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkResponse;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.HttpHeaderParser;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.onesignal.OSNotification;
import com.onesignal.OSNotificationReceivedEvent;
import com.onesignal.OneSignal;
import com.onesignal.OneSignal.OSRemoteNotificationReceivedHandler;

import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Objects;

@SuppressWarnings("unused")
public class NotificationServiceExtension implements OSRemoteNotificationReceivedHandler {

    @Override
    public void remoteNotificationReceived(Context context, OSNotificationReceivedEvent notificationReceivedEvent) {
        OSNotification notification = notificationReceivedEvent.getNotification();
        final String SHARED_PREFERENCES_NAME = "FlutterSharedPreferences";

        final android.content.SharedPreferences preferences;
        preferences = context.getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE);

        SharedPreferences.Editor editor = preferences.edit();


        JSONObject jsonBody = new JSONObject();
        try {
            jsonBody.put("user_id", Objects.requireNonNull(OneSignal.getDeviceState()).getUserId());
            jsonBody.put("title", notification.getTitle());
            jsonBody.put("content", notification.getBody());
            jsonBody.put("received_time", new Date());
            jsonBody.put("notification_id", notification.getNotificationId());
            jsonBody.put("sent_time", notification.getSentTime());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        final String mRequestBody = jsonBody.toString();

        String prefID = "flutter.notification_" + notification.getSentTime();
        editor.putString(prefID , mRequestBody);
        editor.commit();


        notificationReceivedEvent.complete(notification);
    }
}