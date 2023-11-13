package com.evertec.athmovil.athmovil_checkout_flutter.models

import com.google.gson.annotations.SerializedName

data class Items  (

    @SerializedName("name")
    var name: String = "",

    @SerializedName("description")
    var desc: String = "",

    @SerializedName("price")
    var price: Double = 0.0,

    @SerializedName("quantity")
    var quantity: Long = 0,

    @SerializedName("metadata")
    var metadata: String = ""

)