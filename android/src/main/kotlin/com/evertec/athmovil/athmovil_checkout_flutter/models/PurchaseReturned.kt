package com.evertec.athmovil.athmovil_checkout_flutter.models

import com.google.gson.annotations.SerializedName

data class PurchaseReturned (

    @SerializedName("completed")
    var completed: String = "",

    @SerializedName("cartReferenceId")
    var cartReferenceId: String = "",

    @SerializedName("dailyTransactionID")
    var dailyTransactionID: String = "",

    @SerializedName("transactionReference")
    var transactionReference: String = "",

    @SerializedName("date")
    var date: String = "",

    @SerializedName("status")
    var status: String = "",

    @SerializedName("total")
    var total: Double = 0.0,

    @SerializedName("name")
    var name: String = "",

    @SerializedName("phoneNumber")
    var phoneNumber: String = "",

    @SerializedName("email")
    var email: String = "",

    @SerializedName("tax")
    var tax: Double = 0.0,

    @SerializedName("subtotal")
    var subtotal: Double = 0.0,

    @SerializedName("fee")
    var fee: Double = 0.0,

    @SerializedName("netAmount")
    var netAmount: Double = 0.0,

    @SerializedName("metadata1")
    var metadata1: String = "",

    @SerializedName("metadata2")
    var metadata2: String = "",

    @SerializedName("paymentId")
    var paymentId: String = "",

    @SerializedName("referenceNumber")
    var referenceNumber: String = "",

    @SerializedName("items")
    var items: List<Items> = arrayListOf(),

    @SerializedName("itemsSelectedList")
    var itemsSelectedList: List<Items> = arrayListOf(),
    
)
