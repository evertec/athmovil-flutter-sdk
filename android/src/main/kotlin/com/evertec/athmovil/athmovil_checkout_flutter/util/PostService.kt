package com.evertec.athmovil.athmovil_checkout_flutter.util

import com.google.gson.JsonObject
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.Header
import retrofit2.http.POST
import com.evertec.athmovil.athmovil_checkout_flutter.util.ConstantsUtil.RequestConstants.ATHM_API_ROUTE
import com.evertec.athmovil.athmovil_checkout_flutter.util.ConstantsUtil.RequestConstants.ATHM_API_PAYMENT
import com.evertec.athmovil.athmovil_checkout_flutter.util.ConstantsUtil.RequestConstants.ATHM_API_AUTHORIZATION
import org.json.JSONObject
import com.evertec.athmovil.athmovil_checkout_flutter.models.PaymentRequest
import com.evertec.athmovil.athmovil_checkout_flutter.models.PaymentResponse
import com.evertec.athmovil.athmovil_checkout_flutter.models.AuthorizationResponse

interface PostService {
    @Headers("Content-type: application/json")
    @POST(ATHM_API_ROUTE)
    fun sendPost(@Body body: JsonObject) : Call<JsonObject>

    @Headers("Content-type: application/json")
    @POST(ATHM_API_PAYMENT)
    fun paymentPost(@Body body: PaymentRequest, @Header("Host") host: String) : Call<PaymentResponse>

    @Headers("Content-type: application/json")
    @POST(ATHM_API_AUTHORIZATION)
    fun authorizationPayment(@Header("Host") host: String) : Call<AuthorizationResponse>
}
