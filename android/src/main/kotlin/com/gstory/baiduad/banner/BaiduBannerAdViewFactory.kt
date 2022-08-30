package com.gstory.baiduad.banner

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * @Author: gstory
 * @CreateDate: 2022/8/29 11:27
 * @Description: 描述
 */

internal class BaiduBannerAdViewFactory (private val messenger: BinaryMessenger, private val activity: Activity) : PlatformViewFactory(
    StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val params = args as Map<String?, Any?>
        return BaiduBannerAdView(activity,messenger, viewId, params)
    }
}