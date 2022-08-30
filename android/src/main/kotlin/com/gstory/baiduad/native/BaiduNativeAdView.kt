package com.gstory.baiduad.native

import android.app.Activity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.baidu.mobads.sdk.api.BaiduNativeManager
import com.baidu.mobads.sdk.api.ExpressResponse
import com.baidu.mobads.sdk.api.ExpressResponse.*
import com.baidu.mobads.sdk.api.RequestParameters
import com.gstory.baiduad.utils.BaiduLogUtil
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

/**
 * @Author: gstory
 * @CreateDate: 2022/8/29 15:10
 * @Description: 描述
 */

class BaiduNativeAdView(
    var activity: Activity,
    messenger: BinaryMessenger?,
    id: Int,
    params: Map<String?, Any?>
) : PlatformView {

    private val TAG = "NativeAdView"
    private var mContainer: FrameLayout? = null
    private var nativeManager: BaiduNativeManager? = null

    //广告所需参数
    private var codeId: String
    private var appSid: String?
    private var width: Double
    private var height: Double
    private var channel: MethodChannel

    init {
        codeId = params["androidId"] as String
        appSid = params["appSid"] as String
        width = params["width"] as Double
        height = params["height"] as Double
        channel = MethodChannel(messenger!!, "com.gstory.baiduad/NativeAdView_$id")
        mContainer = FrameLayout(activity)
        mContainer?.layoutParams?.width = ViewGroup.LayoutParams.WRAP_CONTENT
        mContainer?.layoutParams?.height = ViewGroup.LayoutParams.WRAP_CONTENT
        loadNativeAd()
    }

    override fun getView(): View {
        return mContainer!!
    }

    override fun dispose() {
        mContainer?.removeAllViews()
    }

    private fun loadNativeAd() {
        nativeManager = BaiduNativeManager(activity, codeId)
        var requestParameters: RequestParameters = RequestParameters.Builder()
            .downloadAppConfirmPolicy(RequestParameters.DOWNLOAD_APP_CONFIRM_ONLY_MOBILE)
            .build()
        nativeManager?.loadExpressAd(requestParameters,
            object : BaiduNativeManager.ExpressAdListener {
                override fun onNativeLoad(p0: MutableList<ExpressResponse>?) {
                    BaiduLogUtil.d("$TAG 信息流广告请求成功")
                    if (p0 != null && p0.size > 0) {
                        var response = p0[0]
                        // 渲染模板
                        renderResponses(response)
                        mContainer?.addView(response.expressAdView)
                    }
                }

                override fun onNativeFail(p0: Int, p1: String?) {
                    BaiduLogUtil.d("$TAG 信息流广告请求失败 $p0 $p1")
                    var map: MutableMap<String, Any?> =
                        mutableMapOf("code" to 0, "message" to "$p0  $p1")
                    channel.invokeMethod("onFail", map)
                }

                override fun onNoAd(p0: Int, p1: String?) {
                    BaiduLogUtil.d("$TAG 信息流无广告返回")
                }

                override fun onVideoDownloadSuccess() {
                    BaiduLogUtil.d("$TAG 信息流广告素材缓存成功")
                }

                override fun onVideoDownloadFailed() {
                    BaiduLogUtil.d("$TAG 信息流广告素材缓存失败")
                }

                override fun onLpClosed() {
                    BaiduLogUtil.d("$TAG 信息流广告落地页面被关闭（返回键或关闭图标）")
                }
            })
    }

    /**
     * 渲染信息流
     */
    private fun renderResponses(response: ExpressResponse) {
        // 注册监听
        response.setInteractionListener(object : ExpressInteractionListener {
            override fun onAdClick() {
                BaiduLogUtil.d("$TAG 信息流广告点击")
                channel.invokeMethod("onClick", "")
            }

            override fun onAdExposed() {
                BaiduLogUtil.d("$TAG 信息流广告曝光")
            }

            override fun onAdRenderFail(adView: View, reason: String, code: Int) {
                BaiduLogUtil.d("$TAG 信息流广告渲染失败 $code $reason")
                var map: MutableMap<String, Any?> =
                    mutableMapOf("code" to 0, "message" to "$code  $reason")
                channel.invokeMethod("onFail", map)
            }

            override fun onAdRenderSuccess(adView: View, width: Float, height: Float) {
                BaiduLogUtil.d("$TAG 信息流广告渲染成功 $width  $height")
                var map: MutableMap<String, Any?> =
                    mutableMapOf("width" to width, "height" to height)
                channel.invokeMethod("onShow", map)
            }

            override fun onAdUnionClick() {
                BaiduLogUtil.d("$TAG 信息流广告联盟官网点击回调")
            }
        })
        response.setAdPrivacyListener(object : ExpressAdDownloadWindowListener {
            override fun onADPrivacyClick() {
                BaiduLogUtil.d("$TAG 信息流广告下载广告 隐私声明点击回调")
            }

            override fun onADPermissionShow() {
                BaiduLogUtil.d("$TAG 信息流广告下载广告 权限弹窗展示回调")
            }

            override fun onADPermissionClose() {
                BaiduLogUtil.d("$TAG 信息流广告下载广告 权限弹窗关闭回调")
            }

            override fun adDownloadWindowShow() {
                BaiduLogUtil.d("$TAG 信息流广告下载弹窗展示回调")
            }

            override fun adDownloadWindowClose() {
                BaiduLogUtil.d("$TAG 信息流广告\t下载弹窗关闭回调")
            }
        })
        response.setAdDislikeListener(object : ExpressDislikeListener {
            override fun onDislikeWindowShow() {
                BaiduLogUtil.d("$TAG 信息流广告负反馈弹窗展示回调\n")
            }

            override fun onDislikeItemClick(reason: String) {
                BaiduLogUtil.d("$TAG 信息流广告负反馈选项点击回调 $reason")
                channel.invokeMethod("onClose", "")
            }

            override fun onDislikeWindowClose() {
                BaiduLogUtil.d("$TAG 信息流广告负反馈弹窗关闭回调")
            }
        })
        response.render()
    }
}