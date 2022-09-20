package com.gstory.baiduad.splash

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * @Author: gstory
 * @CreateDate: 2022/8/29 17:34
 * @Description: 描述
 */

internal class BaiduSplashAdViewFactory (private val messenger: BinaryMessenger, private val activity: Activity) : PlatformViewFactory(
    StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val params = args as Map<*, *>
        return BaiduSplashAdView(activity,messenger, viewId, params)
    }
}