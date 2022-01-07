import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui';
import 'package:ffi/ffi.dart';
import 'package:propertylistserialization/propertylistserialization.dart';
import 'package:filesize/filesize.dart';

class GetMacInfo {
  static String modelName() {
    return "macOS Model Name Dummy";
  }

  static String modelNumber() {
    return _getSysctlValue("hw.model", false);
  }

  static String osVersion() {
    return "OS Version Dummy";
  }

  static String widthResolution() {
    return "W Resolution Dummy";
  }

  static String heightResolution() {
    return "H Resolution Dummy";
  }

  static String boardName() {
    return "Board Name Dummy";
  }

  static String kernelVersion() {
    return _getSysctlValue("kern.version", false);
  }

  static String cpuName() {
    return _getSysctlValue("machdep.cpu.brand_string", false);
  }

  static String cpuArch() {
    String cpusubtype = _getSysctlValue("hw.cpusubtype", true);
    String ret;

    // https://opensource.apple.com/source/xnu/xnu-7195.81.3/osfmk/mach/machine.h.auto.html
    switch (cpusubtype) {
      case "1":
        ret = "ARM64";
        break;
      case "2":
        ret = "ARM64e";
        break;
      case "3":
      case "4":
      case "8":
        ret = "x86_64";
        break;
      default:
        ret = "Unknown (CPU subtype:" + cpusubtype + ")";
        break;
    }
    if (_getSysctlValue("sysctl.proc_translated", true) == "1") {
      ret += " (Translated by Rosetta)";
    }
    return ret;
  }

  static String cpuCores() {
    return _getSysctlValue("hw.physicalcpu_max", true);
  }

  static String chipID() {
    return "Chip ID Dummy";
  }

  static String totalMemoryMB() {
    return filesize(_getSysctlValue("hw.memsize", true)).toString();
  }

  /// Get value from sysctl.
  static String _getSysctlValue(String name, bool isValueInt) {
    // size_t size;
    final oldlenp = malloc<Int64>();
    _sysctlbyname(name.toNativeUtf8(), nullptr, oldlenp);
    // char *machine = malloc(size);
    final oldp = malloc<Int8>(oldlenp.value);
    _sysctlbyname(name.toNativeUtf8(), oldp, oldlenp);
    String value;
    if (isValueInt) {
      value = oldp.cast<Int64>().value.toString();
    } else {
      value = oldp.cast<Utf8>().toDartString();
    }

    malloc.free(oldlenp);
    malloc.free(oldp);
    return value;
  }

  /// Gets or sets information about the system and environment.
  ///
  /// Original(ObjC) Declaration:
  /// ```objective-c
  /// int sysctlbyname(const char *, void *, size_t *, void *, size_t);
  /// ```
  ///
  /// More info: https://developer.apple.com/documentation/kernel/1387446-sysctlbyname
  static int _sysctlbyname(
      Pointer<Utf8> name, Pointer<Int8> oldp, Pointer<Int64> oldlenp) {
    String libSysPath = "/usr/lib/libSystem.dylib";
    final libSys = DynamicLibrary.open(libSysPath);
    final sysctlbyname = libSys.lookup<
        NativeFunction<
            Int32 Function(Pointer<Utf8>, Pointer<Int8>, Pointer<Int64>,
                Pointer<IntPtr>, Int64)>>('sysctlbyname');
    final sysctlByname = sysctlbyname.asFunction<
        int Function(Pointer<Utf8>, Pointer<Int8>, Pointer<Int64>,
            Pointer<IntPtr>, int)>();
    return sysctlByname(name, oldp, oldlenp, nullptr, 0);
  }
}
