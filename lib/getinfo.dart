import 'dart:io';
import 'package:flutter_deviceinfo/getinfo_platform/macos.dart';

import 'getinfo_platform/ios.dart';
import 'getinfo_platform/android.dart';

class GetDeviceInfo {
  static String modelName() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.modelName();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.modelName();
    } else if (Platform.isMacOS) {
      return GetMacInfo.modelName();
    } else {
      return "Unsupported OS";
    }
  }

  static String modelNumber() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.modelNumber();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.modelNumber();
    } else if (Platform.isMacOS) {
      return GetMacInfo.modelNumber();
    } else {
      return "Unsupported OS";
    }
  }

  static String osVersion() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.osVersion();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.osVersion();
    } else if (Platform.isMacOS) {
      return GetMacInfo.osVersion();
    } else {
      return "Unsupported OS";
    }
  }

  static String widthResolution() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.widthResolution();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.widthResolution();
    } else if (Platform.isMacOS) {
      return GetMacInfo.widthResolution();
    } else {
      return "Unsupported OS";
    }
  }

  static String heightResolution() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.heightResolution();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.heightResolution();
    } else if (Platform.isMacOS) {
      return GetMacInfo.heightResolution();
    } else {
      return "Unsupported OS";
    }
  }

  static String boardName() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.boardName();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.boardName();
    } else if (Platform.isMacOS) {
      return GetMacInfo.boardName();
    } else {
      return "Unsupported OS";
    }
  }

  static String kernelVersion() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.kernelVersion();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.kernelVersion();
    } else if (Platform.isMacOS) {
      return GetMacInfo.kernelVersion();
    } else {
      return "Unsupported OS";
    }
  }

  static String cpuName() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.cpuName();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.cpuName();
    } else if (Platform.isMacOS) {
      return GetMacInfo.cpuName();
    } else {
      return "Unsupported OS";
    }
  }

  static String cpuArch() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.cpuArch();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.cpuArch();
    } else if (Platform.isMacOS) {
      return GetMacInfo.cpuArch();
    } else {
      return "Unsupported OS";
    }
  }

  static String cpuCores() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.cpuCores();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.cpuCores();
    } else if (Platform.isMacOS) {
      return GetMacInfo.cpuCores();
    } else {
      return "Unsupported OS";
    }
  }

  static String chipID() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.chipID();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.chipID();
    } else if (Platform.isMacOS) {
      return GetMacInfo.chipID();
    } else {
      return "Unsupported OS";
    }
  }

  static String totalMemoryMB() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.totalMemoryMB();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.totalMemoryMB();
    } else if (Platform.isMacOS) {
      return GetMacInfo.totalMemoryMB();
    } else {
      return "Unsupported OS";
    }
  }
  /* 
  static String gpuName() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.gpuName();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.gpuName();
    } else if (Platform.isMacOS) {
      return GetMacInfo.gpuName();
    } else {
      return "Unsupported OS";
    }
  } */
}
