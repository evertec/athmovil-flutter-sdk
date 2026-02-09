package com.evertec.athmovil.athmovil_checkout_flutter.util

import android.util.Log
import com.google.gson.Gson
import okhttp3.*
import java.io.IOException
import java.util.*

object NewRelicConfig {

    private const val LOG_TAG = "athmCheckoutValidation"

    fun sendEventToNewRelic(
        eventType: String,
        paymentReference: String?,
        merchantAppId: String?,
        paymentStatus: String?,
        buildType: String?
    ) {
        val insertKey = ConstantsUtil.NR_CONSTANT.replace(Regex("[${ConstantsUtil.RVARIBALES}]"), "")
        val url = ConstantsUtil.URL_CONSTANT.replace(Regex("[${ConstantsUtil.RVARIBALES}]"), "")
        val finalBuildType = if (buildType.isNullOrEmpty()) "PROD" else buildType

        val event = mapOf(
            "eventType" to eventType,
            "payment_reference" to paymentReference,
            "merchant_app_id" to merchantAppId,
            "payment_status" to paymentStatus,
            "build_type" to finalBuildType,
            "sdk_platform" to "Android_Flutter",
            "timestamp" to System.currentTimeMillis(),
            "sdk_version" to "4.1.0",
            "device_os_version" to android.os.Build.VERSION.RELEASE,
            "device_os_model" to android.os.Build.MODEL
        )

        val jsonPayload = Gson().toJson(event)
        val body = RequestBody.create(MediaType.parse("application/json"), jsonPayload)
        val request = Request.Builder()
            .url(url)
            .addHeader("X-Insert-Key", insertKey)
            .addHeader("Content-Type", "application/json")
            .post(body)
            .build()

        OkHttpClient().newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                logForDebug("New Relic Event API error: ${e.message}")
            }

            override fun onResponse(call: Call, response: Response) {
                response.use {
                    if (it.isSuccessful) {
                        logForDebug("Event sent to New Relic successfully")
                    } else {
                        logForDebug("New Relic API response error: ${it.code()}")
                    }
                }
            }
        })
    }

    private fun logForDebug(message: String) {
        Log.d(LOG_TAG, message)
    }
}