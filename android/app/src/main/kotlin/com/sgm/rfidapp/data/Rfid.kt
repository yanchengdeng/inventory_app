package com.sgm.rfidapp.data

import android.bluetooth.BluetoothDevice

/**
 * @author  : yanc
 * @date : 2022/7/6
 * @time : 22:15
 * @desc :
 */


//蓝牙设备
data class BtDeviceInfo(val macAddress : BluetoothDevice, val name: String, val rssi: Short,var  isSelected : Boolean )
//1标签 2二维码
enum class LABEL(val type : Int){

    //停止读写
    RFID(1),
    //扫描
    SCAN(2),

}

//设备状态  如果code 是 则data 返回的是读写的数据(rfid )
data class RfidData(val type : Int,val data : List<String>)

