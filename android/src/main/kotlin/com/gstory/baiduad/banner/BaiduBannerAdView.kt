package com.gstory.baiduad.banner

import android.app.Activity
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.baidu.mobads.sdk.api.AdSize
import com.baidu.mobads.sdk.api.AdView
import com.baidu.mobads.sdk.api.AdViewListener
import com.gstory.baiduad.utils.BaiduLogUtil
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import org.json.JSONObject

/**
 * @Author: gstory
 * @CreateDate: 2022/8/29 11:28
 * @Description: 描述
 */

class BaiduBannerAdView(var activity: Activity,
                         messenger: BinaryMessenger?,
                         id: Int,
                         params: Map<*, *>) : PlatformView {

    private val TAG = "BannerAdView"
    private var mContainer: FrameLayout? = null
    private var adView: AdView? = null
    //广告所需参数
    private var codeId: String
    private var appSid: String?
    private var autoplay: Boolean
    private var width: Double
    private var height: Double
    private var channel: MethodChannel

    init {
        codeId = params["androidId"] as String
        appSid = params["appSid"] as String
        autoplay  = params["autoplay"] as Boolean
        width = params["width"] as Double
        height = params["height"] as Double
        channel = MethodChannel(messenger!!, "com.gstory.baiduad/BannerAdView_$id")
        mContainer = FrameLayout(activity)
        mContainer?.layoutParams?.width = ViewGroup.LayoutParams.WRAP_CONTENT
        mContainer?.layoutParams?.height = ViewGroup.LayoutParams.WRAP_CONTENT
        loadBannerAd()
    }

    override fun getView(): View {
        return mContainer!!
    }

    override fun dispose() {
        adView?.destroy()
        mContainer?.removeAllViews()
        adView = null
    }

    private fun loadBannerAd() {
        mContainer?.removeAllViews()
        adView = AdView(activity, null, autoplay, AdSize.Banner, codeId)
        //支持动态设置APPSID，该信息可从移动联盟获得
        if (!appSid.isNullOrEmpty()) {
            adView?.setAppSid(appSid)
        }
//        adView.layoutParams
        adView?.setListener(object : AdViewListener{
            //广告加载成功回调，表示广告相关的资源已经加载完毕，Ready To Show
            override fun onAdReady(p0: AdView?) {
                BaiduLogUtil.d("$TAG  Banner广告加载成功  ${p0 != null} ${p0?.layoutParams?.width} ${p0?.layoutParams?.height}")
            }

            //当广告展现时发起的回调
            override fun onAdShow(p0: JSONObject?) {
                BaiduLogUtil.d("$TAG  Banner广告展现  $p0")
                var map: MutableMap<String, Any?> =
                    mutableMapOf("width" to adView?.layoutParams?.width, "height" to adView?.layoutParams?.height)
                channel.invokeMethod("onShow", map)
            }

            //当广告点击时发起的回调
            override fun onAdClick(p0: JSONObject?) {
                BaiduLogUtil.d("$TAG  Banner广告点击  $p0")
                channel.invokeMethod("onClick", "")
            }

            //	广告加载失败，error对象包含了错误码和错误信息
            override fun onAdFailed(p0: String?) {
                BaiduLogUtil.d("$TAG  Banner广告加载失败 $p0")
                var map: MutableMap<String, Any?> = mutableMapOf("message" to p0)
                channel.invokeMethod("onFail", map)
                dispose()
            }

            override fun onAdSwitch() {
                BaiduLogUtil.d("$TAG  Banner onAdSwitch")
            }

            //当广告关闭时调用
            override fun onAdClose(p0: JSONObject?) {
                BaiduLogUtil.d("$TAG  Banner广告关闭")
                channel.invokeMethod("onClose", "")
                dispose()
            }
        })
        mContainer?.addView(adView)
    }
}