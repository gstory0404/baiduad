package com.gstory.baiduad.splash

import android.app.Activity
import android.view.View
import android.widget.FrameLayout
import com.baidu.mobads.sdk.api.RequestParameters
import com.baidu.mobads.sdk.api.SplashAd
import com.baidu.mobads.sdk.api.SplashInteractionListener
import com.gstory.baiduad.utils.BaiduLogUtil
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


/**
 * @Author: gstory
 * @CreateDate: 2022/8/29 17:34
 * @Description: 描述
 */

class BaiduSplashAdView (var activity: Activity,
                         messenger: BinaryMessenger?,
                         id: Int,
                         params: Map<*, *>) : PlatformView {

    private val TAG = "BannerAdView"
    private var mContainer: FrameLayout
    private var splashAd: SplashAd? = null

    //广告所需参数
    private var codeId: String
    private var appSid: String?
    private var width: Double
    private var height: Double
    private var channel: MethodChannel
    private var timeout: Int

    init {
        codeId = params["androidId"] as String
        appSid = params["appSid"] as String
        width = params["width"] as Double
        height = params["height"] as Double
        timeout = params["timeout"] as Int

        channel = MethodChannel(messenger!!, "com.gstory.baiduad/SplashAdView_$id")
        mContainer = FrameLayout(activity)
        mContainer.layoutParams?.width = width.toInt()
        mContainer.layoutParams?.height = height.toInt()
        loadSplashAd()
    }

    override fun getView(): View {
        return mContainer
    }

    override fun dispose() {
        mContainer.removeAllViews()
        splashAd?.destroy()
    }

    private fun loadSplashAd() {
        // 如果开屏需要load广告和show广告分开，请参考类RSplashManagerActivity的写法
        // 如果需要修改开屏超时时间、隐藏工信部下载整改展示，请设置下面代码;
        val parameters = RequestParameters.Builder()
        // sdk内部默认超时时间为4200，单位：毫秒
        parameters.addExtra(SplashAd.KEY_TIMEOUT, timeout.toString())
        // sdk内部默认值为true
        parameters.addExtra(SplashAd.KEY_DISPLAY_DOWNLOADINFO, "true")
        // 用户点击开屏下载类广告时，是否弹出Dialog
        // 此选项设置为true的情况下，会覆盖掉 {SplashAd.KEY_DISPLAY_DOWNLOADINFO} 的设置
        parameters.addExtra(SplashAd.KEY_POPDIALOG_DOWNLOAD, "true")
        splashAd = SplashAd(activity, codeId, parameters.build(), object :
            SplashInteractionListener {
            override fun onADLoaded() {
                BaiduLogUtil.d("$TAG 开屏广告请求成功")
                splashAd?.show(mContainer)

            }

            override fun onAdFailed(p0: String?) {
                BaiduLogUtil.d("$TAG 开屏广告加载失败 $p0")
                var map: MutableMap<String, Any?> = mutableMapOf("message" to p0)
                channel.invokeMethod("onFail", map)
            }

            override fun onLpClosed() {
                BaiduLogUtil.d("$TAG 开屏广告落地页关闭")
            }

            override fun onAdPresent() {
                BaiduLogUtil.d("$TAG 开屏广告成功展示")
                channel.invokeMethod("onShow", "")
            }

            override fun onAdExposed() {
                BaiduLogUtil.d("$TAG 开屏广告曝光")
            }

            override fun onAdDismissed() {
                BaiduLogUtil.d("$TAG 开屏广告关闭")
                channel.invokeMethod("onClose", "")
            }

            override fun onAdSkip() {
                BaiduLogUtil.d("$TAG 开屏广告跳过")
            }

            override fun onAdClick() {
                BaiduLogUtil.d("$TAG 开屏广告被点击")
                channel.invokeMethod("onClick", "")
            }

            override fun onAdCacheSuccess() {
                BaiduLogUtil.d("$TAG 开屏广告缓存成功")
            }

            override fun onAdCacheFailed() {
                BaiduLogUtil.d("$TAG 开屏广告缓存失败")
            }

        })
        splashAd?.setAppSid(appSid)
        // 【可选】【Bidding】设置广告的底价，单位：分
//        splashAd?.setBidFloor(100)
        // 请求并展示广告
//        splashAd?.loadAndShow(mContainer)
        splashAd?.load()
    }
}