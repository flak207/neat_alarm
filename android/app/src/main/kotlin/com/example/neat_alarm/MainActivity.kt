package com.example.neat_alarm

import android.content.ContentResolver
import android.content.Context
import android.media.RingtoneManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "kea.dev/neat_alarm").setMethodCallHandler { call, result ->
            if ("drawableToUri" == call.method) {
                val resourceId = this@MainActivity.resources.getIdentifier(call.arguments as String, "drawable", this@MainActivity.packageName)
                result.success(resourceToUriString(this@MainActivity.applicationContext, resourceId))
            }
            if ("getAlarmUri" == call.method) {
                result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM).toString())
            }
            if ("getAllSounds" == call.method) {
                val manager = RingtoneManager(this@MainActivity)
                manager.setType(RingtoneManager.TYPE_ALL)
                val cursor = manager.cursor

                val list = HashMap<String, String>()
                while (cursor.moveToNext()) {
                    val id = cursor.getString(RingtoneManager.ID_COLUMN_INDEX)
                    val uri = cursor.getString(RingtoneManager.URI_COLUMN_INDEX)
                    val title = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)

                    list.set(title, "$uri/$id")
                }

                result.success(list)
            }
        }
    }

    private fun resourceToUriString(context: Context, resId: Int): String? {
        return (ContentResolver.SCHEME_ANDROID_RESOURCE + "://"
                + context.resources.getResourcePackageName(resId)
                + "/"
                + context.resources.getResourceTypeName(resId)
                + "/"
                + context.resources.getResourceEntryName(resId))
    }
}
