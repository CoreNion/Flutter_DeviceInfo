import 'dart:io';
import 'getinfo_platform/ios.dart';
import 'getinfo_platform/android.dart';

class GetDeviceInfo {
  static String modelName() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.modelName();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.modelName();
    } else {
      return "Unsupported OS";
    }
  }

  static String modelNumber() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.modelNumber();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.modelNumber();
    } else {
      return "Unsupported OS";
    }
  }

  static String osVersion() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.osVersion();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.osVersion();
    } else {
      return "Unsupported OS";
    }
  }

  static String widthResolution() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.widthResolution();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.widthResolution();
    } else {
      return "Unsupported OS";
    }
  }

  static String heightResolution() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.heightResolution();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.heightResolution();
    } else {
      return "Unsupported OS";
    }
  }

  static String boardName() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.boardName();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.boardName();
    } else {
      return "Unsupported OS";
    }
  }

  static String kernelVersion() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.kernelVersion();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.kernelVersion();
    } else {
      return "Unsupported OS";
    }
  }

  static String cpuName() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.cpuName();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.cpuName();
    } else {
      return "Unsupported OS";
    }
  }

  static String cpuArch() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.cpuArch();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.cpuArch();
    } else {
      return "Unsupported OS";
    }
  }

  static String cpuCores() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.cpuCores();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.cpuCores();
    } else {
      return "Unsupported OS";
    }
  }

  static String chipID() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.chipID();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.chipID();
    } else {
      return "Unsupported OS";
    }
  }

  static String totalMemoryMB() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.totalMemoryMB();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.totalMemoryMB();
    } else {
      return "Unsupported OS";
    }
  }

  static String gpuName() {
    if (Platform.isAndroid) {
      return GetDroidDeviceInfo.gpuName();
    } else if (Platform.isIOS) {
      return GetiDeviceInfo.gpuName();
    } else {
      return "Unsupported OS";
    }
  }
}
