package com.luojie.erapp.inventory_app.data

import android.bluetooth.BluetoothDevice

/**
 * @author  : yanc
 * @date : 2022/7/6
 * @time : 22:15
 * @desc :
 */



data class BtDeviceInfo(val macAddress : BluetoothDevice, val name: String, val rssi: Short,var  isSelected : Boolean )