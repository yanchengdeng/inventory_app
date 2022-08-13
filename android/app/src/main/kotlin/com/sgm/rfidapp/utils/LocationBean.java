package com.sgm.rfidapp.utils;

public class LocationBean {

    private double lat;
    private double lng;
//    private String countryName;
//    private String countryCode;
    private String address;

    public LocationBean(double latitude, double longitude,String address) {
        this.lat = latitude;
        this.lng = longitude;
//        this.countryName = countryName;
//        this.countryCode = countryCode;
        this.address = address;
    }

    public double getLatitude() {
        return lat;
    }

    public void setLatitude(double latitude) {
        this.lat = latitude;
    }

    public double getLongitude() {
        return lng;
    }

    public void setLongitude(double longitude) {
        this.lng = longitude;
    }

//    public String getCountryName() {
//        return countryName;
//    }
//
//    public void setCountryName(String countryName) {
//        this.countryName = countryName;
//    }
//
//    public String getCountryCode() {
//        return countryCode;
//    }
//
//    public void setCountryCode(String countryCode) {
//        this.countryCode = countryCode;
//    }
//
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
//
//    @Override
//    public String toString() {
//        return "Location{" +
//                "latitude=" + latitude +
//                ", longitude=" + longitude +
//                ", countryName='" + countryName + '\'' +
//                ", countryCode='" + countryCode + '\'' +
//                '}';
//    }
}