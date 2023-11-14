package com.evertec.athmovil.athmovil_checkout_flutter.models

import com.evertec.athmovil.athmovil_checkout_flutter.models.Items
import com.google.gson.annotations.SerializedName

data class AutorizationData (

    @SerializedName("env")
    var env: String = "",

    @SerializedName("publicToken")
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

    @SerializedName("ecommerceId")
    var ecommerceId: String = "",

    @SerializedName("ecommerceStatus")
    var ecommerceStatus: String = "",

    @SerializedName("referenceNumber")
    var referenceNumber: String = "",

    @SerializedName("dailyTransactionId")
    var dailyTransactionID: String = "",

    @SerializedName("totalRefundedAmount")
    var totalRefundedAmount: String = "",

    @SerializedName("netAmount")
    var netAmount: Double = 0.0,

    @SerializedName("fee")
    var fee: Double = 0.0,

    @SerializedName("message")
    var message: String = "",

    @SerializedName("name")
    var name: String = ""

)

