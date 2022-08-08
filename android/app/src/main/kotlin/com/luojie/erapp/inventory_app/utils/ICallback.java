package com.luojie.erapp.inventory_app.utils;

public interface ICallback<RESULT> {

    void onResult(RESULT result);

    void onError(Throwable error);

}