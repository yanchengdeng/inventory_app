package com.luojie.erapp.inventory_app.data

import android.bluetooth.BluetoothDevice

/**
 * @author  : yanc
 * @date : 2022/7/6
 * @time : 22:15
 * @desc :
 */


//蓝牙设备
data class BtDeviceInfo(val macAddress : BluetoothDevice, val name: String, val rssi: Short,var  isSelected : Boolean )

enum class READ_STATUS(status : Int){
    //未操作RFID
    NO_HANDLE(0),
    //蓝牙底座已连接
    BLUE_TEETH_OK(1),
    //已创建读写器
    CREATE_OK(2),
    //正在读写
    READING_DATA(3),
    //停止读写
    STOP_READING(4),

}

//设备状态  如果code 是 则data 返回的是读写的数据(rfid )
data class RfidStatus(val code : READ_STATUS,val data : List<String>)

