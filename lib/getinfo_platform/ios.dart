import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:propertylistserialization/propertylistserialization.dart';
import 'package:filesize/filesize.dart';

class GetiDeviceInfo {
  static String modelName() {
    // 仮 tentative
    return _getMGCopyAnswerValue("DeviceName");
  }

  static String modelNumber() {
    return _getMGCopyAnswerValue("HWModelStr") +
        " (" +
        _getMGCopyAnswerValue("ModelNumber") +
        ")";
  }

  static String osVersion() {
    if (_getMGCopyAnswerValue("DeviceClass") == "iPhone") {
      return "iOS " + _getMGCopyAnswerValue("ProductVersion");
    } else if (_getMGCopyAnswerValue("DeviceClass") == "iPad") {
      return "iPadOS " + _getMGCopyAnswerValue("ProductVersion");
    } else {
      return _getMGCopyAnswerValue("ProductVersion");
    }
  }

  static String widthResolution() {
    return "W Resolution Dummy";
  }

  static String heightResolution() {
    return "H Resolution Dummy";
  }

  static String boardName() {
    return _getSysctlValue("hw.model", false);
  }

  static String kernelVersion() {
    return _getSysctlValue("kern.version", false);
  }

  static String cpuName() {
    // https://www.theiphonewiki.com/wiki/Application_Processor
    switch (chipID()) {
      case "s5l8960x":
        return "Apple A7";
      case "s5l8965x":
        return "Apple A7 (iPad Air)";
      case "t7000":
        return "Apple A8";
      case "s8000":
        return "Apple A9 (Samsung)";
      case "s8003":
        return "Apple A9 (TSMC)";
      case "s8001":
        return "Apple A9X";
      case "t8010":
        return "Apple A10 Fusion";
      case "t8015":
        return "Apple A11 Bionic";
      case "t8020":
        return "Apple A12 Bionic";
      case "t8027":
        // According to chip id, A12Z is exactly the same as A12X lol.
        String board = boardName();
        if (board == "J420AP" || board == "J421AP") {
          return "Apple A12Z Bionic";
        } else {
          return "Apple A12X Bionic";
        }
      case "t8030":
        return "Apple A13 Bionic";
      case "t8101":
        return "Apple A14 Bionic";
      case "t8103":
        return "Apple M1";
      case "t8110":
        return "Apple A15 Bionic";
      case "t6000":
        return "Apple M1 Pro";
      case "t6001":
        return "Apple M1 Max";
      default:
        return "Unknown";
    }
  }

  static String cpuArch() {
    return _getMGCopyAnswerValue("CPUArchitecture");
  }

  static String cpuCores() {
    return _getSysctlValue("hw.physicalcpu_max", true);
  }

  static String chipID() {
    return _getMGCopyAnswerValue("HardwarePlatform");
  }

  static String totalMemoryMB() {
    return filesize(_getSysctlValue("hw.memsize", true)).toString();
  }

  static String gpuName() {
    return "GPU Name Dummy";
  }

  /// Functions for handling MGCopyAnswer with dart。
  static String _getMGCopyAnswerValue(String property) {
    // String to C String
    Pointer<Utf8> hardwarePlatform = property.toNativeUtf8();
    // C String to CFString, after doing MGCopyAnswer
    Pointer<IntPtr> answer =
        _MGCopyAnswer(_CFStringCreateWithCString(hardwarePlatform, 134217984));
    // CFPropertyListRef(MGCopyAnswer's return) to CFDataRef(Binary Plist type)
    Pointer<IntPtr> answerCFData = _CFPropertyListCreateData(answer);
    // CFDataRef to UInt8 to Unint8List (dart becomes a readable type.)
    Uint8List answerUint8ListData = _CFDataGetBytePtr(answerCFData)
        .asTypedList(_CFDataGetLength(answerCFData));
    // Unint8List to ByteData
    ByteData answerByteData = ByteData.sublistView(answerUint8ListData);
    // At last. After serialization binary plist, we can get Chip ID.
    return PropertyListSerialization.propertyListWithData(answerByteData)
        as String;
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

  /// Get more detailed information value about the device from private library.
  ///
  /// Original(ObjC) Declaration:
  /// ```objective-c
  /// CFPropertyListRef MGCopyAnswer(CFStringRef property);
  /// ```
  ///
  /// Header(Property list is here): https://github.com/hirakujira/CPU-Identifier/blob/master/CPU%20test/MobileGestalt.h
  static Pointer<IntPtr> _MGCopyAnswer(Pointer<IntPtr> property) {
    String dylibPath = "/usr/lib/libMobileGestalt.dylib";
    final libMobileGestalt = DynamicLibrary.open(dylibPath);
    final MGCopyAnswer = libMobileGestalt
        .lookup<NativeFunction<Pointer<IntPtr> Function(Pointer<IntPtr>)>>(
            'MGCopyAnswer');
    final mgCopyAnswer =
        MGCopyAnswer.asFunction<Pointer<IntPtr> Function(Pointer<IntPtr>)>();
    return mgCopyAnswer(property);
  }

  /// Creates an immutable string(CFString) from a C string.
  ///
  /// Original(ObjC) Declaration:
  /// ```objective-c
  /// CFStringRef CFStringCreateWithCString(CFAllocatorRef alloc, const char *cStr, CFStringEncoding encoding);
  /// ```
  ///
  /// More info: https://developer.apple.com/documentation/corefoundation/1542942-cfstringcreatewithcstring?language=objc
  static Pointer<IntPtr> _CFStringCreateWithCString(
      Pointer<Utf8> cStr, int count) {
    String cfPath =
        "/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation";
    final cF = DynamicLibrary.open(cfPath);
    final CFStringCreateWithCString = cF.lookup<
        NativeFunction<
            Pointer<IntPtr> Function(Pointer<IntPtr>, Pointer<Utf8>,
                Uint32)>>('CFStringCreateWithCString');
    final cFStringCreateWithCString = CFStringCreateWithCString.asFunction<
        Pointer<IntPtr> Function(Pointer<IntPtr>, Pointer<Utf8>, int)>();
    return cFStringCreateWithCString(nullptr, cStr, count);
  }

  /// Returns a CFData object containing a serialized representation of a given property list in a specified format.
  ///
  /// Original(ObjC) Declaration:
  /// ```objective-c
  /// CFDataRef CFPropertyListCreateData(CFAllocatorRef allocator, CFPropertyListRef propertyList, CFPropertyListFormat format, CFOptionFlags options, CFErrorRef *error);
  /// ```
  ///
  /// More info: https://developer.apple.com/documentation/corefoundation/1429998-cfpropertylistcreatedata?language=objc
  static Pointer<IntPtr> _CFPropertyListCreateData(
      Pointer<IntPtr> cfPropertyList) {
    String cfPath =
        "/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation";
    final cF = DynamicLibrary.open(cfPath);
    final CFPropertyListCreateData = cF.lookup<
        NativeFunction<
            Pointer<IntPtr> Function(Pointer<IntPtr>, Pointer<IntPtr>, Uint32,
                Pointer<Uint64>, Pointer<IntPtr>)>>('CFPropertyListCreateData');
    final cfPropertyListCreateData = CFPropertyListCreateData.asFunction<
        Pointer<IntPtr> Function(Pointer<IntPtr>, Pointer<IntPtr>, int,
            Pointer<Uint64>, Pointer<IntPtr>)>();
    return cfPropertyListCreateData(
        nullptr, cfPropertyList, 200, nullptr, nullptr);
  }

  /// Returns a read-only pointer to the bytes of a CFData object.
  ///
  /// Original(ObjC) Declaration:
  /// ```objective-c
  /// const UInt8 * CFDataGetBytePtr(CFDataRef theData);
  /// ```
  ///
  /// More info: https://developer.apple.com/documentation/corefoundation/1543330-cfdatagetbyteptr?language=objc
  static Pointer<Uint8> _CFDataGetBytePtr(Pointer<IntPtr> cfData) {
    String cfPath =
        "/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation";
    final cF = DynamicLibrary.open(cfPath);
    final CFDataGetBytePtr =
        cF.lookup<NativeFunction<Pointer<Uint8> Function(Pointer<IntPtr>)>>(
            'CFDataGetBytePtr');
    final cfDataGetBytePtr =
        CFDataGetBytePtr.asFunction<Pointer<Uint8> Function(Pointer<IntPtr>)>();
    return cfDataGetBytePtr(cfData);
  }

  /// Returns the number of bytes contained by a CFData object.
  ///
  /// Original(ObjC) Declaration:
  /// ```objective-c
  /// CFIndex CFDataGetLength(CFDataRef theData);
  /// ```
  ///
  /// More info: https://developer.apple.com/documentation/corefoundation/1541728-cfdatagetlength?language=objc
  static int _CFDataGetLength(Pointer<IntPtr> cfData) {
    String cfPath =
        "/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation";
    final cF = DynamicLibrary.open(cfPath);
    final CFDataGetLength =
        cF.lookup<NativeFunction<Int32 Function(Pointer<IntPtr>)>>(
            'CFDataGetLength');
    final cfDataGetLength =
        CFDataGetLength.asFunction<int Function(Pointer<IntPtr>)>();
    return cfDataGetLength(cfData);
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
