import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
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
    Pointer<_utsname> uts = malloc<_utsname>();
    _uname(uts);

    // Kernel OS name (e.x. Linux)
    Array<Int8> sysname = uts.ref.sysname;
    // Kernel release (e.x. 5.4.86-qgki-g481f7eca2ed5)
    Array<Int8> release = uts.ref.release;
    // Kernel version (e.x. #1 SMP PREEMPT Wed Oct 27 15:02:49 CST 2021)
    Array<Int8> version = uts.ref.version;
    // Kernel architecture (e.x. aarch64)
    Array<Int8> machine = uts.ref.machine;

    malloc.free(uts);

    // Array<Int8> to List<int>
    String aint8ToString(Array<Int8> aInt8) {
      List<int> list = [];
      for (var i = 0; i < 65; i++) {
        list.add(aInt8[i]);
      }
      return utf8.decode(list);
    }

    return aint8ToString(sysname) +
        " " +
        aint8ToString(release) +
        "\n" +
        aint8ToString(version) +
        " " +
        aint8ToString(machine);
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

  /// Get name and information about current kernel. (libc)
  ///
  /// header: https://android.googlesource.com/platform/bionic/+/refs/tags/android-12.0.0_r21/libc/include/sys/utsname.h
  ///
  /// man page: https://man7.org/linux/man-pages/man2/uname.2.html
  static int _uname(Pointer<_utsname> value) {
    String soPath = "";
    if (File("/system/lib64/libc.so").existsSync()) {
      soPath = "/system/lib64/libc.so";
    } else {
      soPath = "/system/lib/libc.so";
    }
    final libc = DynamicLibrary.open(soPath);

    final _sysconf =
        libc.lookup<NativeFunction<Int32 Function(Pointer<_utsname>)>>('uname');
    final sysconf = _sysconf.asFunction<int Function(Pointer<_utsname>)>();

    return sysconf(value);
  }
}

class _utsname extends Struct {
  // char sysname[SYS_NMLN(65)];
  @Array(65)
  external Array<Int8> sysname;

  // char nodename[SYS_NMLN(65)];
  @Array(65)
  external Array<Int8> nodename;

  // char release[SYS_NMLN(65)];
  @Array(65)
  external Array<Int8> release;

  // char version[SYS_NMLN(65)];
  @Array(65)
  external Array<Int8> version;

  // char machine[SYS_NMLN(65)];
  @Array(65)
  external Array<Int8> machine;

  // char domainanme[SYS_NMLN(65)];
  @Array(65)
  external Array<Int8> domainanme;
}
