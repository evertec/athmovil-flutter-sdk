package com.evertec.athmovil.athmovil_checkout_flutter

import ATHMPayment
import PaymentResultFlag
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager.NameNotFoundException
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import com.evertec.athmovil.athmovil_checkout_flutter.util.ConstantsUtil
import com.evertec.athmovil.athmovil_checkout_flutter.util.ConstantsUtil.RequestConstants
import com.evertec.athmovil.athmovil_checkout_flutter.util.PostService
import com.google.gson.JsonObject
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.NewIntentListener
import io.flutter.plugin.common.PluginRegistry.Registrar
import okhttp3.OkHttpClient
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.security.SecureRandom
import java.security.cert.X509Certificate
import java.util.*
import java.util.concurrent.TimeUnit
import javax.net.ssl.SSLContext
import javax.net.ssl.SSLSocketFactory
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager

/** AthmovilCheckoutFlutterPlugin */
class AthmovilCheckoutFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var activity: Activity? = null
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var buildType: String
    private lateinit var postsService: PostService

    /**
     * Default constructor for AthmovilCheckoutFlutterPlugin.
     *
     * Use this constructor when adding this plugin to an app with v2 embedding.
     */
    constructor() {
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, RequestConstants.ATHM_CHANNEL_NAME)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    /**
     * Use this method to support the version v1.
     */
    fun registerWith(registrar: Registrar) {
        val channel = MethodChannel(registrar.messenger(), RequestConstants.ATHM_CHANNEL_NAME)
        val plugin = AthmovilCheckoutFlutterPlugin()
        plugin.activity = registrar.activity()
        plugin.context = plugin.activity?.baseContext!!
        channel.setMethodCallHandler(plugin)
        registrar.addNewIntentListener(plugin.resultListener)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == RequestConstants.ATHM_CHANNEL_OPENATHM) {
            if (call.hasArgument(RequestConstants.ATHM_PAYMENT)) {
                val paymentArguments =
                    call.argument<String>(RequestConstants.ATHM_PAYMENT).toString()
                val timeoutArguments =
                    call.argument<Int>(RequestConstants.ATHM_TIMEOUT) ?: 0
                val paymentArgumentsJson = JSONObject(paymentArguments)
                val paymentId = call.argument<String>(RequestConstants.ATHM_PAYMENT_ID).toString()
                PaymentResultFlag.getApplicationInstance().paymentRequest = ATHMPayment(
                    paymentId,
                    paymentArgumentsJson.getString(RequestConstants.ATHM_BUSINESS_TOKEN),
                    paymentArguments
                )
                buildType = call.argument<String>(RequestConstants.ATHM_BUILD_TYPE).toString()

                execute(
                    json = paymentArguments,
                    timeout = validateTimeout(timeoutArguments.toLong()),
                    buildType = buildType
                )
            }
        } else {
            result.notImplemented()
        }
    }

    private fun validateTimeout(timeout: Long): Long {
        val newTimeout = timeout * 1000
        return when {
            newTimeout < RequestConstants.ATHM_MIN_TIMEOUT -> RequestConstants.ATHM_MIN_TIMEOUT
            newTimeout > RequestConstants.ATHM_MAX_TIMEOUT -> RequestConstants.ATHM_MAX_TIMEOUT
            else -> newTimeout
        }
    }

    private val resultListener = NewIntentListener { intent ->
        validateIntentResponse(intent)
        false
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun execute(json: String, timeout: Long, buildType: String) {
        val athmInfo: PackageInfo
        var athmVersionCode = 0
        Log.e("buildType", buildType)
        var athmBundleId: String = ""
        athmBundleId = if (buildType == "null") {
            RequestConstants.ATHM_APP_PATH
        } else {
            RequestConstants.ATHM_APP_PATH + buildType
        }
        var intent = activity?.packageManager?.getLaunchIntentForPackage(athmBundleId)
        try {
            athmInfo = context.packageManager.getPackageInfo(athmBundleId, 0)
            athmVersionCode = athmInfo.versionCode
        } catch (e: NameNotFoundException) {

        }
        if (intent == null) {
            intent = Intent(Intent.ACTION_VIEW)
            intent.data = Uri.parse(RequestConstants.ATHM_MARKET_URL)
        }
        intent.putExtra(RequestConstants.ATHM_BUNDLE, context.packageName)
        intent.putExtra(RequestConstants.ATHM_JSON_DATA, json)
        intent.putExtra(RequestConstants.ATHM_PAYMENT_DURATION_TIME, timeout)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
        context.startActivity(intent)
    }

    ///
    /// Validate Payment Response Section.
    ///
    private fun validateIntentResponse(@NonNull intent: Intent) {
        ///
        ///Extracting response from intent extras
        ///
        val paymentResult: String? = intent.getStringExtra(RequestConstants.ATHM_PAYMENT_RESULT)
        if (paymentResult == null) {
            validateCurrentPaymentInMemory()
        } else {
            PaymentResultFlag.getApplicationInstance().paymentRequest = null
            channel.invokeMethod(RequestConstants.ATHM_PAYMENT_RESULT, paymentResult)
        }
    }

    private fun validateCurrentPaymentInMemory() {
        /// Check if the singleton has a valid payment
        val athmPayment: ATHMPayment? = PaymentResultFlag.getApplicationInstance().paymentRequest
        PaymentResultFlag.getApplicationInstance().paymentRequest = null
        /// If its the dummy case it will return always cancelled status
        when {
            athmPayment == null -> {
                return
            }
            athmPayment.publicToken.lowercase(
                Locale.getDefault()
            ) == RequestConstants.ATHM_DUMMY_TOKEN -> {

                channel.invokeMethod(
                    RequestConstants.ATHM_PAYMENT_RESULT,
                    RequestConstants.ATHM_CANCELLED_RESULT
                )
                return
            }

            else -> {
                verifyPaymentStatus(context, athmPayment)
            }
        }
    }

    private fun setServicesFromActivity(activity: Activity?) {
        if (activity == null) return
        this.activity = activity
    }

    /**
     * Call ATH Móvil service to verify transaction status in case ATH Móvil app does not return it.
     *
     * @param context - Application context **/

    private fun verifyPaymentStatus(context: Context?, athmPayment: ATHMPayment?) {

        var url: String = ""
        url = when (buildType) {
            ".qa" -> {
                RequestConstants.ATHM_INTERNAL_TEST_URL
            }
            ".piloto" -> {
                RequestConstants.ATHM_PILOTO_URL
            }
            else -> {
                RequestConstants.ATHM_PRODUCTION_URL
            }
        }
        val retrofit: Retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .client(getHttpClient())
            .build()
        postsService = retrofit.create(PostService::class.java)
        val jsonObject = JsonObject()
        jsonObject.addProperty("publicToken", athmPayment?.publicToken)
        jsonObject.addProperty("paymentID", athmPayment?.paymentId)
        val call: retrofit2.Call<JsonObject> = postsService.sendPost(jsonObject)
        call.enqueue(object : Callback<JsonObject?> {
            @Override
            override fun onResponse(call: Call<JsonObject?>?, response: Response<JsonObject?>) {
                // pass response to the example activity
                PaymentResultFlag.getApplicationInstance().paymentRequest = null
                if (response.isSuccessful() && response.body() != null &&
                    !response.body().toString()
                        .contains(ConstantsUtil.ErrorConstants.ATHM_ERROR_CODE)
                ) {
                    val paymentResponse: String = response.body().toString()
                    channel.invokeMethod(RequestConstants.ATHM_PAYMENT_RESULT, paymentResponse)
                } else {
                    channel.invokeMethod(
                        RequestConstants.ATHM_PAYMENT_RESULT,
                        RequestConstants.ATHM_CANCELLED_RESULT
                    )
                }
            }

            @Override
            override fun onFailure(call: Call<JsonObject?>?, t: Throwable) {
                channel.invokeMethod(
                    ConstantsUtil.ErrorConstants.ATHM_EXCEPTION,
                    ConstantsUtil.ErrorConstants.ATHM_PAYMENT_VALIDATION_FAILED
                )
            }
        })
    }

    /**
     * Manage certificates
     * TODO: Remove certificate bypass for production
     */
    private fun getHttpClient(): OkHttpClient? {
        return try {
            val builder: OkHttpClient.Builder = OkHttpClient.Builder()


            // Create a trust manager that does not validate certificate chains
            val trustAllCerts: Array<TrustManager> =
                arrayOf<TrustManager>(object : X509TrustManager {
                    @SuppressLint("TrustAllX509TrustManager")
                    @Override
                    override fun checkClientTrusted(
                        chain: Array<java.security.cert.X509Certificate?>?,
                        authType: String?
                    ) {
                    }

                    @SuppressLint("TrustAllX509TrustManager")
                    @Override
                    override fun checkServerTrusted(
                        chain: Array<java.security.cert.X509Certificate?>?,
                        authType: String?
                    ) {
                    }

                    override fun getAcceptedIssuers(): Array<X509Certificate?>? {
                        return arrayOf()
                    }
                }
                )
            // Install the all-trusting trust manager
            val sslContext: SSLContext = SSLContext.getInstance("SSL")
            sslContext.init(null, trustAllCerts, SecureRandom())
            // Create an ssl socket factory with our all-trusting manager
            val sslSocketFactory: SSLSocketFactory = sslContext.getSocketFactory()
            builder.sslSocketFactory(sslSocketFactory, trustAllCerts[0] as X509TrustManager)
            builder.hostnameVerifier { hostname, session -> true }

            //Handling connection timeout fo prod
            builder.connectTimeout(30, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)

            // Handling headers for the entire app network calls
            //            addHeaders(builder);
            builder.build()
        } catch (e: Exception) {
            OkHttpClient.Builder().build()
        }
    }

    override fun onDetachedFromActivity() {
        channel.setMethodCallHandler(null);
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        binding.addOnNewIntentListener(resultListener)
        setServicesFromActivity(binding.activity)
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        (binding.lifecycle as HiddenLifecycleReference)
            .lifecycle
            .addObserver(LifecycleEventObserver { source, event ->
                if (event == Lifecycle.Event.ON_RESUME) {
                    validateCurrentPaymentInMemory()
                }
            })
        binding.addOnNewIntentListener(resultListener)
        setServicesFromActivity(binding.activity)
        activity = binding.activity
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        channel.setMethodCallHandler(null)
    }
}
