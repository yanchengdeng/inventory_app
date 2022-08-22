package com.sgm.rfidapp.utils;

/**
 * @Describe ：纪要说明
 * @Author : yanc
 * @Date : 2022/8/22
 * @Time : 16:31
 **/
public class LocationInfo {

    private double lat;
    private double lng;
    private String address;

    public LocationInfo(double lat, double lng, String address) {
        this.lat = lat;
        this.lng = lng;
        this.address = address;
    }

    public double getLat() {
        return lat;
    }

    public void setLat(double lat) {
        this.lat = lat;
    }

    public double getLng() {
        return lng;
    }

    public void setLng(double lng) {
        this.lng = lng;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
