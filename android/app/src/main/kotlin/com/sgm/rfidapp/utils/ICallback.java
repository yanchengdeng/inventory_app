package com.sgm.rfidapp.utils;

public interface ICallback<RESULT> {

    void onResult(RESULT result);

    void onError(Throwable error);

}