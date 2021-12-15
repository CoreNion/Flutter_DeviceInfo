import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:propertylistserialization/propertylistserialization.dart';

class GetiDeviceInfo {
  static String modelName() {
    return chipID() + " Device";
  }

  static String modelNumber() {
    return "Model Number Dummy";
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
    return "Kernel Version Dummy";
  }

  static String cpuName() {
    return "CPU Name Dummy";
  }

  static String cpuArch() {
    return "CPU Arch Dummy";
  }

  static String cpuCores() {
    return "CPU Cores Dummy";
  }

  static String chipID() {
    return _getMGCopyAnswerValue("HardwarePlatform");
  }

  static String totalMemoryMB() {
    return "Total Memory Dummy MB";
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
}
