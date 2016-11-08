package org.dasfoo.delern.notifications;

import android.util.Log;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import org.dasfoo.delern.util.LogUtil;

/**
 * Created by katarina on 10/7/16.
 */

public class DelernFirebaseMessagingService extends FirebaseMessagingService {

    /**
     * Class information for logging.
     */
    private static final String TAG = LogUtil.tagFor(DelernFirebaseMessagingService.class);

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        // Handle data payload of FCM messages.
        Log.d(TAG, "FCM Message Id: " + remoteMessage.getMessageId());
        Log.d(TAG, "FCM Notification Message: " +
                remoteMessage.getNotification());
        Log.d(TAG, "FCM Data Message: " + remoteMessage.getData());
    }
}
