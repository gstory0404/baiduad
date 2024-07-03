package com.gstory.baiduad.reward

import android.annotation.SuppressLint
import android.content.Context
import com.baidu.mobads.sdk.api.RewardVideoAd
import com.gstory.baiduad.BaiduAdEventPlugin
import com.gstory.baiduad.utils.BaiduLogUtil

/**
 * @Author: gstory
 * @CreateDate: 2022/8/29 10:30
 * @Description: 激励广告
 */

object BaiduRewardAd : RewardVideoAd.RewardVideoAdListener {
    private val TAG = "RewardAd"
    private lateinit var context: Context
    private var rewardVideoAd: RewardVideoAd? = null

    private var codeId: String? = null
    private var useSurfaceView: Boolean? = false
    private var userId: String = ""
    private var rewardName: String = ""
    private var rewardAmount: Int = 0
    private var customData: String = ""
    private var isShowDialog: Boolean? = false
    private var useRewardCountdown: Boolean? = false
    private var appSid: String? = null

    fun load(context: Context, params: Map<*, *>) {
        this.context = context
        this.codeId = params["androidId"] as String
        this.useSurfaceView = params["useSurfaceView"] as Boolean
        this.userId = params["userId"] as String
        this.rewardName = params["rewardName"] as String
        this.rewardAmount = params["rewardAmount"] as Int
        this.customData = params["customData"] as String
        this.isShowDialog = params["isShowDialog"] as Boolean
        this.useRewardCountdown = params["useRewardCountdown"] as Boolean
        this.appSid = params["appSid"] as String
        loadRewardVideoAd()
    }

    @SuppressLint("StaticFieldLeak")
    private fun loadRewardVideoAd() {
        rewardVideoAd = RewardVideoAd(context, codeId, this, useSurfaceView!!)
        //设置点击跳过时是否展示提示弹框
        rewardVideoAd?.setShowDialogOnSkip(isShowDialog!!)
        //设置用户id
        rewardVideoAd?.setUserId(userId)
        //设置自定义参数
        rewardVideoAd?.setExtraInfo(customData)
        //支持动态设置APPSID，该信息可从移动联盟获得
        if(!appSid.isNullOrEmpty()){
            rewardVideoAd?.setAppSid(appSid)
        }
        rewardVideoAd?.load()
    }

    fun showAd() {
        if (rewardVideoAd == null && !rewardVideoAd?.isReady!!) {
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onUnReady")
            BaiduAdEventPlugin.sendContent(map)
            return
        }
        rewardVideoAd?.show()
    }

    //广告展示回调
    override fun onAdShow() {
        BaiduLogUtil.d("$TAG 激励广告广告展示")
        var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onShow")
        BaiduAdEventPlugin.sendContent(map)
        return
    }

    //点击时回调
    override fun onAdClick() {
        BaiduLogUtil.d("$TAG 激励广告点击")
        var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onClick")
        BaiduAdEventPlugin.sendContent(map)
    }

    //关闭回调，附带播放进度
    override fun onAdClose(p0: Float) {
        BaiduLogUtil.d("$TAG 激励广告关闭回调，附带播放进度 $p0")
        var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onClose")
        BaiduAdEventPlugin.sendContent(map)
        rewardVideoAd = null
    }

    //广告加载失败
    override fun onAdFailed(p0: String?) {
        BaiduLogUtil.d("$TAG 激励广告加载失败 $p0")
        var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onFail", "code" to 0, "message" to p0)
        BaiduAdEventPlugin.sendContent(map)
    }

    //视频物料缓存成功
    override fun onVideoDownloadSuccess() {
        BaiduLogUtil.d("$TAG 激励广告视频物料缓存成功")
    }

    //视频物料缓存失败
    override fun onVideoDownloadFailed() {
        BaiduLogUtil.d("$TAG 激励广告视频物料缓存失败")
    }

    //播放完成回调
    override fun playCompletion() {
        BaiduLogUtil.d("$TAG 激励广告播放完成回调")
    }

    //视频跳过，附带播放进度（当前播放进度/视频总时长 取值范围0-1）
    override fun onAdSkip(p0: Float) {
        BaiduLogUtil.d("$TAG 激励广告视频跳过，附带播放进度（当前播放进度/视频总时长 取值范围0-1）$p0")
    }

    //广告加载成功
    override fun onAdLoaded() {
        BaiduLogUtil.d("$TAG 广告加载成功")
        var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onReady")
        BaiduAdEventPlugin.sendContent(map)
    }

    //激励视频奖励回调
    override fun onRewardVerify(p0: Boolean) {
        BaiduLogUtil.d("$TAG 激励视频奖励回调 $p0")
        var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onVerify","verify" to p0,"rewardName" to rewardName, "rewardAmount" to rewardAmount)
        BaiduAdEventPlugin.sendContent(map)
    }
}