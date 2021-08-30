package com.evertec.athmovil.athmovil_checkout_flutter.util;

import com.google.gson.JsonObject;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.Headers;
import retrofit2.http.POST;

import static com.evertec.athmovil.athmovil_checkout_flutter.util.ConstantsUtil.RequestConstants.ATHM_API_ROUTE;

public interface PostService {
    @Headers({
            "Content-type: application/json"
    })
    @POST(ATHM_API_ROUTE)
    Call<JsonObject> sendPost(@Body JsonObject body);
}
