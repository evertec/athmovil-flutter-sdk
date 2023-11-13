package com.evertec.athmovil.athmovil_checkout_flutter.models

import com.google.gson.annotations.SerializedName

data class Ecommerce (

    @SerializedName("ecommerceId")
    var ecommerceId: String = "",

    @SerializedName("auth_token")
    var authToken: String = "",

)