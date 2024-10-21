package com.gstory.baiduad

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.baidu.mobads.sdk.api.AdSettings
import com.baidu.mobads.sdk.api.BDAdConfig
import com.baidu.mobads.sdk.api.BDDialogParams
import com.baidu.mobads.sdk.api.MobadsPermissionSettings
import com.gstory.baiduad.interstitial.BaiduInterstitialAd
import com.gstory.baiduad.native.BaiduNativeAdViewFactory
import com.gstory.baiduad.reward.BaiduRewardAd
import com.gstory.baiduad.splash.BaiduSplashAdViewFactory
import com.gstory.baiduad.utils.BaiduLogUtil
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** BaiduadPlugin */
class BaiduadPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var applicationContext: Context? = null
    private var mActivity: Activity? = null
    private var mFlutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity
        //注册横幅广告
//        mFlutterPluginBinding?.platformViewRegistry?.registerViewFactory(
//            "com.gstory.baiduad/BannerAdView",
//            BaiduBannerAdViewFactory(mFlutterPluginBinding?.binaryMessenger!!, mActivity!!)
//        )
        //注册信息流广告
        mFlutterPluginBinding?.platformViewRegistry?.registerViewFactory(
            "com.gstory.baiduad/NativeAdView",
            BaiduNativeAdViewFactory(mFlutterPluginBinding?.binaryMessenger!!, mActivity!!)
        )
        //注册开屏广告
        mFlutterPluginBinding?.platformViewRegistry?.registerViewFactory(
            "com.gstory.baiduad/SplashAdView",
            BaiduSplashAdViewFactory(mFlutterPluginBinding?.binaryMessenger!!, mActivity!!)
        )
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mActivity = binding.activity
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "baiduad")
        channel.setMethodCallHandler(this)
        applicationContext = flutterPluginBinding.applicationContext
        mFlutterPluginBinding = flutterPluginBinding
        //注册event
        BaiduAdEventPlugin().onAttachedToEngine(flutterPluginBinding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        mActivity = null
    }

    override fun onDetachedFromActivity() {
        mActivity = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        //注册初始化
        if (call.method == "register") {
            val appId = call.argument<String>("androidAppId")
            val appName = call.argument<String>("appName")
            val debug = call.argument<Boolean>("debug")
            val bdAdConfig = BDAdConfig.Builder()
                .setAppName(appName)
                .setAppsid(appId)
                .setDialogParams(
                    BDDialogParams.Builder()
                        .setDlDialogType(BDDialogParams.TYPE_BOTTOM_POPUP)
                        .setDlDialogAnimStyle(BDDialogParams.ANIM_STYLE_NONE)
                        .build()
                )
                .setBDAdInitListener(object : BDAdConfig.BDAdInitListener{
                    override fun success() {
                        BaiduLogUtil.d("百青藤SDK初始化成功")
                        mActivity?.runOnUiThread {
                            result.success(true)
                        }
                    }

                    override fun fail() {
                        BaiduLogUtil.d("百青藤SDK初始化失败")
                        mActivity?.runOnUiThread {
                            result.success(false)
                        }
                    }
                })
                .build(applicationContext)
            bdAdConfig.init()
            BaiduLogUtil.setAppName("BaiduAd")
            BaiduLogUtil.setShow(debug!!)
            //隐私敏感权限API&限制个性化广告推荐
        } else if (call.method == "privacy") {
            MobadsPermissionSettings.setPermissionReadDeviceID(call.argument<Boolean>("readDeviceID")!!)
            MobadsPermissionSettings.setPermissionLocation(call.argument<Boolean>("location")!!)
            MobadsPermissionSettings.setPermissionStorage(call.argument<Boolean>("storage")!!)
            MobadsPermissionSettings.setPermissionAppList(call.argument<Boolean>("appList")!!)
            MobadsPermissionSettings.setLimitPersonalAds(call.argument<Boolean>("personalAds")!!)
            result.success(true)
            //获取sdk版本
        } else if (call.method == "getSDKVersion") {
            result.success(AdSettings.getSDKVersion())
            //预加载激励广告
        } else if (call.method == "loadRewardAd") {
            BaiduRewardAd.load(applicationContext!!, call.arguments as Map<*, *>)
            result.success(true)
            //展示激励广告
        } else if (call.method == "showRewardAd") {
            BaiduRewardAd.showAd()
            result.success(true)
            //预加载插屏广告
        } else if (call.method == "loadInterstitialAd") {
            BaiduInterstitialAd.load(mActivity!!, call.arguments as Map<*, *>)
            result.success(true)
            //展示插屏广告
        } else if (call.method == "showInterstitialAd") {
            BaiduInterstitialAd.showInterstitialAd()
            result.success(true)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
