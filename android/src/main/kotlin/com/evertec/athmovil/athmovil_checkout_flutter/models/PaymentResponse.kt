package com.evertec.athmovil.athmovil_checkout_flutter.models

import com.evertec.athmovil.athmovil_checkout_flutter.models.Ecommerce
import com.google.gson.annotations.SerializedName

data class PaymentResponse (
    
    @SerializedName("status")
    var status: String = "",

    @SerializedName("data")
    var data: Ecommerce? = null,

    @SerializedName("message")
    var message: String = "",
    
    @SerializedName("errorcode")
    var errorcode: String = ""

)
