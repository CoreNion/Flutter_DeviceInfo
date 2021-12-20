import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:filesize/filesize.dart';

class GetDroidDeviceInfo {
  static String modelName() {
    return systemPropertyGet("ro.product.manufacturer") +
        " " +
        systemPropertyGet("ro.product.model");
  }

  static String modelNumber() {
    return systemPropertyGet("ro.product.name");
  }

  static String osVersion() {
    return "Android " +
        systemPropertyGet("ro.build.version.release") +
        " (API: " +
        systemPropertyGet("ro.build.version.sdk") +
        ") " +
        systemPropertyGet("ro.build.version.incremental") +
        "\n" +
        systemPropertyGet("ro.build.display.id");
  }

  static String widthResolution() {
    return "W Resolution Dummy";
  }

  static String heightResolution() {
    return "H Resolution Dummy";
  }

  static String boardName() {
    return systemPropertyGet("ro.product.board");
  }

  static String kernelVersion() {
    return "Kernel Version Dummy";
  }

  static String cpuName() {
    return "CPU Name Dummy";
  }

  static String cpuArch() {
    return systemPropertyGet("ro.product.cpu.abi");
  }

  static String cpuCores() {
    // 0x0060 = _SC_NPROCESSORS_CONF
    return _sysconf(0x0060).toString();
  }

  static String chipID() {
    return "Chip ID Dummy";
  }

  static String totalMemoryMB() {
    // _SC_PHYS_PAGES(0x0062) * _SC_PAGE_SIZE(0x0028)
    return filesize(_sysconf(0x0062) * _sysconf(0x0028)).toString();
  }

  static String gpuName() {
    return "GPU Name Dummy";
  }

  /// Get system property(build.prop)'s value.
  ///
  /// (Using __system_property_get() from android's libc.so)
  static String systemPropertyGet(String name) {
    // Check having 64bit library.
    String soPath = "";
    if (File("/system/lib64/libc.so").existsSync()) {
      soPath = "/system/lib64/libc.so";
    } else {
      soPath = "/system/lib/libc.so";
    }

    final libc = DynamicLibrary.open(soPath);

    // int __system_property_get(const char* __name, char* __value);
    // header: https://android.googlesource.com/platform/bionic/+/refs/tags/android-12.0.0_r21/libc/include/sys/system_properties.h
    // While __system_property_get is deprecated, but using __system_property_read_callback is very difficult.
    final __system_property_get = libc
        .lookup<NativeFunction<Int32 Function(Pointer<Utf8>, Pointer<Int8>)>>(
            '__system_property_get');
    final system_property_get = __system_property_get
        .asFunction<int Function(Pointer<Utf8>, Pointer<Int8>)>();

    // Set char* __value
    final pointer = calloc<Int8>();
    // 92 is PROP_VALUE_MAX's value.
    pointer.value = 92;

    system_property_get(name.toNativeUtf8(), pointer);
    String value = pointer.cast<Utf8>().toDartString();
    calloc.free(pointer);
    return value;
  }

  /// Get configuration information at run time. (libc)
  ///
  /// header: https://android.googlesource.com/platform/bionic/+/refs/tags/android-12.0.0_r21/libc/include/bits/sysconf.h
  ///
  /// man page: https://man7.org/linux/man-pages/man3/sysconf.3.html
  static int _sysconf(int value) {
    String soPath = "";
    if (File("/system/lib64/libc.so").existsSync()) {
      soPath = "/system/lib64/libc.so";
    } else {
      soPath = "/system/lib/libc.so";
    }
    final libc = DynamicLibrary.open(soPath);

    final _sysconf =
        libc.lookup<NativeFunction<Int32 Function(Int32)>>('sysconf');
    final sysconf = _sysconf.asFunction<int Function(int)>();

    return sysconf(value);
  }
}
