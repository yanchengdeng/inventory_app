package com.luojie.erapp.inventory_app.data

import android.bluetooth.BluetoothDevice

/**
 * @author  : yanc
 * @date : 2022/7/6
 * @time : 22:15
 * @desc :
 */

 class BtDeviceInfo(dev: BluetoothDevice, rssi: Int) {
    var dev: BluetoothDevice
    var rssi: Int

    init {
        this.dev = dev
        this.rssi = rssi
    }
}