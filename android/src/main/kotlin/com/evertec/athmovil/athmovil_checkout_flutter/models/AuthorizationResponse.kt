package com.evertec.athmovil.athmovil_checkout_flutter.models

import com.google.gson.annotations.SerializedName
import com.evertec.athmovil.athmovil_checkout_flutter.models.AutorizationData
import androidx.annotation.Keep

@Keep
data class AuthorizationResponse (
    
    @SerializedName("status")
    var status: String = "",

    @SerializedName("data")
    var data: AutorizationData? = null

)
