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
