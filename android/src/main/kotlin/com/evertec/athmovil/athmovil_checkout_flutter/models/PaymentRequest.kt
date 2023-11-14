package com.evertec.athmovil.athmovil_checkout_flutter.models

import com.evertec.athmovil.athmovil_checkout_flutter.models.Items
import com.google.gson.annotations.SerializedName

data class PaymentRequest (

    @SerializedName("env")
    var env: String = "",

    @SerializedName(value="publicToken", alternate= ["businessToken"])
    var publicToken: String = "",

    @SerializedName("timeout")
    var timeout: Long = 0,

    @SerializedName("total")
    var total: Double = 0.0,

    @SerializedName("tax")
    var tax: Double = 0.0,

    @SerializedName("subtotal")
    var subtotal: Double = 0.0,

    @SerializedName("metadata1")
    var metadata1: String = "",

    @SerializedName("metadata2")
    var metadata2: String = "",

    @SerializedName("items")
    var items: List<Items> = arrayListOf(),

    @SerializedName("phoneNumber")
    var phoneNumber: String = "",

)
