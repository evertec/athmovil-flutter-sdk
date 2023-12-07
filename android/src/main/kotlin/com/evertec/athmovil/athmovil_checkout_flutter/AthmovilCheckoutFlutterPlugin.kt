package com.evertec.athmovil.athmovil_checkout_flutter

import ATHMPayment
import PaymentResultFlag
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
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
import com.evertec.athmovil.athmovil_checkout_flutter.models.PaymentRequest
import com.evertec.athmovil.athmovil_checkout_flutter.models.PaymentResponse
import com.evertec.athmovil.athmovil_checkout_flutter.models.PurchaseReturned
import com.evertec.athmovil.athmovil_checkout_flutter.models.AuthorizationResponse
import com.google.gson.Gson
import java.lang.Exception
import android.widget.ProgressBar
import android.app.AlertDialog
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

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
    private lateinit var alertDialog: AlertDialog


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
        val paymentArguments = call.argument<String>(RequestConstants.ATHM_PAYMENT).toString()
        val timeoutArguments = call.argument<Int>(RequestConstants.ATHM_TIMEOUT) ?: 0
        val paymentArgumentsJson = JSONObject(paymentArguments)
        val paymentId = call.argument<String>(RequestConstants.ATHM_PAYMENT_ID).toString()
        val athmPayment = ATHMPayment(
            paymentId,
            paymentArgumentsJson.getString(RequestConstants.ATHM_BUSINESS_TOKEN),
            paymentArguments
        )
        // Set the Payment Request in the Singleton
        PaymentResultFlag.getApplicationInstance().paymentRequest = athmPayment
        buildType = call.argument<String>(RequestConstants.ATHM_BUILD_TYPE).toString()
        if(call.hasArgument(RequestConstants.ATHM_PAYMENT)) {
            //RESET TOKEN AUTHORIZATION
            val sharedPref = activity?.getSharedPreferences("FlutterSharedPreferences",Context.MODE_PRIVATE)
            sharedPref?.edit()?.putString("flutter.authToken","")?.apply()
            if(call.method == RequestConstants.ATHM_CHANNEL_OPENATHM) {                                      
                execute(
                    json = paymentArguments,
                    timeout = validateTimeout(timeoutArguments.toLong()),
                    buildType = buildType
                )
            }else if(call.method == RequestConstants.ATHM_SEND_PAYMENT) {
                sendPayment(paymentArguments, timeoutArguments)
            }        
        }else{
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
        val athmBundleId = if (buildType == "null") {
            RequestConstants.ATHM_APP_PATH
        } else {
            if(buildType == ".qacert"){
                RequestConstants.ATHM_APP_PATH + ".qa"
            }else{
                RequestConstants.ATHM_APP_PATH + buildType
            }
        }
        var intent = activity?.packageManager?.getLaunchIntentForPackage(athmBundleId)
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
        val paymentResult: String? = intent.getStringExtra(RequestConstants.ATHM_PAYMENT_RESULT)
        if (paymentResult == null) {            
            validateCurrentPaymentInMemory()
        } else {
            try{
                val paymentReturn = Gson().fromJson(paymentResult, PurchaseReturned::class.java)
                if(paymentReturn.status == RequestConstants.ATHM_COMPLETED_RESULT){
                    //GET AUTHTOKEN
                    val sharedPref = activity?.getSharedPreferences("FlutterSharedPreferences",Context.MODE_PRIVATE)
                    val authToken = sharedPref?.getString("flutter.authToken","") ?: ""
                    if(authToken.isEmpty()){
                        PaymentResultFlag.getApplicationInstance().paymentRequest = null
                        channel.invokeMethod(RequestConstants.ATHM_PAYMENT_RESULT, paymentResult)
                    }else{
                        authorizationPayment(paymentResult)
                    }
                }else{
                    PaymentResultFlag.getApplicationInstance().paymentRequest = null
                    channel.invokeMethod(RequestConstants.ATHM_PAYMENT_RESULT, paymentResult)
                }
            }catch (e: Exception){
                channel.invokeMethod(
                    ConstantsUtil.ErrorConstants.ATHM_EXCEPTION,
                    ConstantsUtil.ErrorConstants.ATHM_RESPONSE_EXCEPTION
                )
            }

        }
    }

    /**
     * Call ATH Móvil service to authorizate payment transaction.
     * @param paymentResult - paymentResult athm movil **/
    private fun authorizationPayment(paymentResult: String){
        try{
            showLoading()
            val paymentReturn = Gson().fromJson(paymentResult, PurchaseReturned::class.java)
            val url = baseUrlAWS()
            val baseurl = "https://$url"
            val retrofit: Retrofit? = getHttpClient()?.let {
                Retrofit.Builder()
                    .baseUrl(baseurl)
                    .addConverterFactory(GsonConverterFactory.create())
                    .client(it)
                    .build()
            }
            postsService = retrofit?.create(PostService::class.java) ?: throw IllegalStateException("Retrofit instance is null")
            val call: Call<AuthorizationResponse> = postsService.authorizationPayment(url)
            call.enqueue(object : Callback<AuthorizationResponse?> {
                @Override
                override fun onResponse(
                    call: Call<AuthorizationResponse?>,
                    response: Response<AuthorizationResponse?>
                ) {
                    hideLoading()
                    if (response.isSuccessful && response.body() != null){
                        //RESET TOKEN AUTHORIZATION
                        val sharedPref = activity?.getSharedPreferences("FlutterSharedPreferences",Context.MODE_PRIVATE)
                        sharedPref?.edit()?.putString("flutter.authToken","")?.apply()
                        //SET PARAMS RESPONSE AUTHORIZATION
                        val referenceNumber =  response.body()?.data?.referenceNumber ?: ""
                        val dailyTransactionID =  response.body()?.data?.dailyTransactionID ?: ""
                        val fee =  response.body()?.data?.fee ?: 0.0
                        val netAmount =  response.body()?.data?.netAmount ?: 0.0
                        paymentReturn.referenceNumber = referenceNumber
                        paymentReturn.dailyTransactionID = dailyTransactionID
                        paymentReturn.fee = fee
                        paymentReturn.netAmount = netAmount
                        PaymentResultFlag.getApplicationInstance().paymentRequest = null
                        val paymentResultString: String = Gson().toJson(paymentReturn)
                        channel.invokeMethod(RequestConstants.ATHM_PAYMENT_RESULT, paymentResultString)
                    } else {
                        failedResult(paymentResult)
                    }
                }
                @Override
                override fun onFailure(call: Call<AuthorizationResponse?>, t: Throwable) {
                    hideLoading()
                    failedResult(paymentResult)
                }
            })
        }catch (e: Exception){
            failedResult(paymentResult)
        }
    }

    private fun failedResult(paymentResult: String){
        hideLoading()
        try {
            val paymentReturn = Gson().fromJson(paymentResult, PurchaseReturned::class.java)
            paymentReturn.status = RequestConstants.ATHM_FAILED_RESULT
            PaymentResultFlag.getApplicationInstance().paymentRequest = null
            val paymentResultString: String = Gson().toJson(paymentReturn)
            channel.invokeMethod(RequestConstants.ATHM_PAYMENT_RESULT, paymentResultString)
        }catch (e: Exception){
            PaymentResultFlag.getApplicationInstance().paymentRequest = null
            channel.invokeMethod(
                RequestConstants.ATHM_PAYMENT_RESULT,
                RequestConstants.ATHM_FAILED_RESULT
            )
        }
    }

    private fun validateCurrentPaymentInMemory() {
        //GET AUTHTOKEN
        val sharedPref = activity?.getSharedPreferences("FlutterSharedPreferences",Context.MODE_PRIVATE)
        val authToken = sharedPref?.getString("flutter.authToken","") ?: ""
        /// Check if the singleton has a valid payment
        val athmPayment: ATHMPayment? = PaymentResultFlag.getApplicationInstance().paymentRequest
        PaymentResultFlag.getApplicationInstance().paymentRequest = null       
        when {
            authToken.isNotEmpty() ->{// its validate authToken the new flow payment secure
                return 
            }
            athmPayment == null -> {
                return        
            } // its the dummy case it will return always cancelled status
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
                verifyPaymentStatus(athmPayment)
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

    private fun verifyPaymentStatus(athmPayment: ATHMPayment?) {

        val url = when (buildType) {
            ".qa" -> {
                RequestConstants.ATHM_INTERNAL_TEST_URL
            }
            ".qacert" -> {
                RequestConstants.ATHM_INTERNAL_TEST_URL
            }
            ".piloto" -> {
                RequestConstants.ATHM_PILOTO_URL
            }
            else -> {
                RequestConstants.ATHM_PRODUCTION_URL
            }
        }
        val retrofit: Retrofit? = getHttpClient()?.let {
            Retrofit.Builder()
                .baseUrl(url)
                .addConverterFactory(GsonConverterFactory.create())
                .client(it)
                .build()
        }
        postsService = retrofit?.create(PostService::class.java) ?: throw IllegalStateException("Retrofit instance is null")
        val jsonObject = JsonObject()
        jsonObject.addProperty("publicToken", athmPayment?.publicToken)
        jsonObject.addProperty("paymentID", athmPayment?.paymentId)
        val call: Call<JsonObject> = postsService.sendPost(jsonObject)
        call.enqueue(object : Callback<JsonObject?> {
            @Override
            override fun onResponse(call: Call<JsonObject?>, response: Response<JsonObject?>) {
                // pass response to the example activity
                PaymentResultFlag.getApplicationInstance().paymentRequest = null
                if (response.isSuccessful && response.body() != null &&
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
            override fun onFailure(call: Call<JsonObject?>, t: Throwable) {
                channel.invokeMethod(
                    ConstantsUtil.ErrorConstants.ATHM_EXCEPTION,
                    ConstantsUtil.ErrorConstants.ATHM_PAYMENT_VALIDATION_FAILED
                )
            }
        })
    }

     /**
    * Call ATH Móvil service to send payment transaction.
    * @param paymentArguments - Object Payment
    * @param timeoutArguments - Timeout **/
    private fun sendPayment(paymentArguments: String, timeoutArguments: Int) {
         showLoading()
        val url = baseUrlAWS()
        val paymentArgumentsJson = JSONObject(paymentArguments)
        val paymentRequest = Gson().fromJson(paymentArguments, PaymentRequest::class.java)
        paymentRequest?.env = buildType
        paymentRequest?.timeout = timeoutArguments.toLong()
        val baseurl = "https://$url"
        val retrofit: Retrofit? = getHttpClient()?.let {
            Retrofit.Builder()
                .baseUrl(baseurl)
                .addConverterFactory(GsonConverterFactory.create())
                .client(it)
                .build()
        }
         postsService = retrofit?.create(PostService::class.java) ?: throw IllegalStateException("Retrofit instance is null")
         val call: Call<PaymentResponse>? =
             paymentRequest?.let { postsService.paymentPost(it, url) }
         call?.enqueue(object : Callback<PaymentResponse?> {
             @Override
             override fun onResponse(
                 call: Call<PaymentResponse?>,
                 response: Response<PaymentResponse?>
             ) {
                hideLoading()
                 if (response.isSuccessful && response.body() != null){
                     if( response.body()?.status == "success"){
                         //SAVE AUTHTOKEN
                         val authToken =  response.body()?.data?.authToken
                         val sharedPref =  activity?.getSharedPreferences("FlutterSharedPreferences",Context.MODE_PRIVATE)
                         val editor = sharedPref?.edit()
                         editor?.putString("flutter.authToken",authToken)?.apply()
                         //SET PAYMENT SECURE REQUEST
                         val ecommerceId =  response.body()?.data?.ecommerceId
                         val phoneNumber = paymentArgumentsJson.getString("phoneNumber")
                         val publicToken = paymentArgumentsJson.getString(RequestConstants.ATHM_BUSINESS_TOKEN)
                         paymentArgumentsJson.put("ecommerceId", ecommerceId)
                         paymentArgumentsJson.put("phoneLine", phoneNumber)
                         paymentArgumentsJson.put("publicToken", publicToken)
                         paymentArgumentsJson.put("version", "3.0")
                         paymentArgumentsJson.put("timeout", timeoutArguments.toString())
                         paymentArgumentsJson.put("expiresIn", timeoutArguments.toString())
                         //OPEN ATHM MOVIL
                         execute(
                             json = paymentArgumentsJson.toString(),
                             timeout = validateTimeout(timeoutArguments.toLong()),
                             buildType = buildType
                         )
                     }else{
                         channel.invokeMethod(
                             ConstantsUtil.ErrorConstants.ATHM_EXCEPTION,
                             ConstantsUtil.ErrorConstants.ATHM_RESPONSE_EXCEPTION
                         )
                     }
                 } else {
                     channel.invokeMethod(
                         ConstantsUtil.ErrorConstants.ATHM_EXCEPTION,
                         ConstantsUtil.ErrorConstants.ATHM_RESPONSE_EXCEPTION
                     )
                 }
             }
             @Override
             override fun onFailure(call: Call<PaymentResponse?>, t: Throwable) {
                 hideLoading()
                 channel.invokeMethod(
                     ConstantsUtil.ErrorConstants.ATHM_EXCEPTION,
                     ConstantsUtil.ErrorConstants.ATHM_RESPONSE_EXCEPTION
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
                arrayOf(@SuppressLint("CustomX509TrustManager")
                object : X509TrustManager {
                    @SuppressLint("TrustAllX509TrustManager")
                    @Override
                    override fun checkClientTrusted(
                        chain: Array<X509Certificate?>?,
                        authType: String?
                    ) {}

                    @SuppressLint("TrustAllX509TrustManager")
                    @Override
                    override fun checkServerTrusted(
                        chain: Array<X509Certificate?>?,
                        authType: String?
                    ) {}

                    override fun getAcceptedIssuers(): Array<X509Certificate?> {
                        return arrayOf()
                    }
                })
            // Install the all-trusting trust manager
            val sslContext: SSLContext = SSLContext.getInstance("SSL")
            sslContext.init(null, trustAllCerts, SecureRandom())
            // Create an ssl socket factory with our all-trusting manager
            val sslSocketFactory: SSLSocketFactory = sslContext.socketFactory
            builder.sslSocketFactory(sslSocketFactory, trustAllCerts[0] as X509TrustManager)
            builder.hostnameVerifier { _, _ -> true }

            //Handling connection timeout fo prod
            builder.connectTimeout(30, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)

            // Handling headers for the entire app network calls
            val sharedPref = activity?.getSharedPreferences("FlutterSharedPreferences",Context.MODE_PRIVATE)
            val authToken = sharedPref?.getString("flutter.authToken","") ?: ""
            if(authToken.isNotEmpty()){
                builder.addInterceptor { chain ->
                    val request = chain.request().newBuilder().addHeader("Authorization", "Bearer $authToken").build()
                    chain.proceed(request)
                }.build()
            }

            builder.build()
        } catch (e: Exception) {
            OkHttpClient.Builder().build()
        }
    }

    override fun onDetachedFromActivity() {
        channel.setMethodCallHandler(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        binding.addOnNewIntentListener(resultListener)
        setServicesFromActivity(binding.activity)
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        (binding.lifecycle as HiddenLifecycleReference)
            .lifecycle
            .addObserver(LifecycleEventObserver { _, event ->
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

    private fun baseUrlAWS() : String{
        return when (buildType) {
            ".qa" -> {
                RequestConstants.ATHM_AWS_QA_URL
            }
            ".qacert" -> {
                RequestConstants.ATHM_AWS_CERT_URL
            }
            else -> {
                RequestConstants.ATHM_AWS_PROD_URL
            }
        }
    }

    private fun showLoading() {
        runBlocking {
            GlobalScope.launch(Dispatchers.Main) {
                val progressBar = ProgressBar(activity)
                val alertDialogBuilder = AlertDialog.Builder(activity)
                alertDialogBuilder.setView(progressBar)
                alertDialogBuilder.setCancelable(false)
                alertDialog = alertDialogBuilder.create()
                alertDialog.show()
            }
        }
    }

    private fun hideLoading() {
        runBlocking {
            GlobalScope.launch(Dispatchers.Main) {
                if (alertDialog.isShowing) {
                    alertDialog.dismiss()
                }
            }
        }
    }

}
