package com.gstory.baiduad.interstitial

import android.annotation.SuppressLint
import android.app.Activity
import com.baidu.mobads.sdk.api.ExpressInterstitialAd
import com.baidu.mobads.sdk.api.ExpressInterstitialListener
import com.gstory.baiduad.BaiduAdEventPlugin
import com.gstory.baiduad.utils.BaiduLogUtil

/**
 * @Author: gstory
 * @CreateDate: 2022/8/29 11:03
 * @Description: 模版插屏广告
 */

@SuppressLint("StaticFieldLeak")
object BaiduInterstitialAd : ExpressInterstitialListener {

    private val TAG = "InterstitialAd"

    private lateinit var context: Activity
    private var codeId: String? = null
    private var interstitialAd: ExpressInterstitialAd? = null

    fun load(context: Activity, params: Map<*, *>) {
        this.context = context
        this.codeId = params["androidId"] as String
        loadInterstitialAd()
    }

    //预加载插屏广告
    private fun loadInterstitialAd() {
        interstitialAd = ExpressInterstitialAd(context, codeId)
        interstitialAd?.setLoadListener(this)
        // 设置下载弹窗，默认为false
        interstitialAd?.setDialogFrame(true);
        interstitialAd?.load()
    }

    fun showInterstitialAd() {
        BaiduLogUtil.d("$TAG  showInterstitialAd  ${interstitialAd?.isReady}")
        if (interstitialAd == null || !interstitialAd?.isReady!!) {
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "interactAd", "onAdMethod" to "onUnReady")
            BaiduAdEventPlugin.sendContent(map)
            BaiduLogUtil.d("$TAG  素材未准备好")
            return
        }
        interstitialAd?.show()
    }

    //插屏广告加载成功
    override fun onADLoaded() {
        BaiduLogUtil.d("$TAG  插屏广告加载成功")
    }

    //插屏广告点击
    override fun onAdClick() {
        BaiduLogUtil.d("$TAG  插屏广告点击")
        var map: MutableMap<String, Any?> = mutableMapOf("adType" to "interactAd", "onAdMethod" to "onClick")
        BaiduAdEventPlugin.sendContent(map)
    }

    //广告被关闭
    override fun onAdClose() {
        BaiduLogUtil.d("$TAG  插屏广告关闭")
        var map: MutableMap<String, Any?> = mutableMapOf("adType" to "interactAd", "onAdMethod" to "onClose")
        BaiduAdEventPlugin.sendContent(map)
    }

    //广告请求失败
    override fun onAdFailed(p0: Int, p1: String?) {
        BaiduLogUtil.d("$TAG  插屏加载失败")
        var map: MutableMap<String, Any?> = mutableMapOf("adType" to "interactAd", "onAdMethod" to "onFail", "code" to p0, "message" to p1)
        BaiduAdEventPlugin.sendContent(map)
    }

    override fun onNoAd(p0: Int, p1: String?) {
        BaiduLogUtil.d("$TAG  模版插屏无广告 $p0  $p1")
        var map: MutableMap<String, Any?> = mutableMapOf("adType" to "interactAd", "onAdMethod" to "onFail", "code" to p0, "message" to p1)
        BaiduAdEventPlugin.sendContent(map)
    }

    //	广告曝光成功
    override fun onADExposed() {
        BaiduLogUtil.d("$TAG  模版插屏曝光")
    }

    //广告曝光失败
    override fun onADExposureFailed() {
        BaiduLogUtil.d("$TAG  模版插屏曝光失败")
    }

    override fun onAdCacheSuccess() {
        BaiduLogUtil.d("$TAG  模版插屏视频缓存成功")
        var map: MutableMap<String, Any?> = mutableMapOf("adType" to "interactAd", "onAdMethod" to "onReady")
        BaiduAdEventPlugin.sendContent(map)
    }

    override fun onAdCacheFailed() {
        BaiduLogUtil.d("$TAG  模版插屏视频缓存失败")
    }

    override fun onLpClosed() {
        BaiduLogUtil.d("$TAG  模版插屏onLpClosed")
    }
}