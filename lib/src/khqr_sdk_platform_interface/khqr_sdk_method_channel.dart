import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:khqr_sdk/src/model/deeplink_data/deeplink_data.dart';
import 'package:khqr_sdk/src/model/deeplink_info/deeplink_info.dart';
import 'package:khqr_sdk/src/model/individual_info/individual_info.dart';
import 'package:khqr_sdk/src/model/khqr_decoded_data/khqr_decoded_data.dart';
import 'package:khqr_sdk/src/model/merchant_info/merchant_info.dart';

import 'khqr_sdk_platform_interface.dart';
import '../model/khqr_data/khqr_data.dart';

/// An implementation of [KhqrSdkPlatform] that uses method channels.
class MethodChannelKhqrSdk extends KhqrSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('khqr_sdk');

  @override
  Future<KhqrData?> generateIndividual(IndividualInfo info) async {
    final jsonData = await methodChannel.invokeMethod(
      'generateIndividual',
      jsonDecode(jsonEncode(info)),
    );
    return KhqrData.fromJson(jsonDecode(jsonData));
  }

  @override
  Future<KhqrData?> generateMerchant(MerchantInfo info) async {
    final jsonData = await methodChannel.invokeMethod(
      'generateMerchant',
      jsonDecode(jsonEncode(info)),
    );
    return KhqrData.fromJson(jsonDecode(jsonData));
  }

  @override
  Future<bool> verify(String qrCode) async {
    if (qrCode.isEmpty) return false;
    final valid = await methodChannel.invokeMethod<bool>('verify', {
      'qrCode': qrCode,
    });
    return valid ?? false;
  }

  @override
  Future<KhqrDecodedData?> decode(String qrCode) async {
    if (qrCode.isEmpty) return null;
    final jsonData = await methodChannel.invokeMethod('decode', {
      'qrCode': qrCode,
    });
    return KhqrDecodedData.fromJson(jsonDecode(jsonData));
  }

  @override
  Future<Map<String, dynamic>?> decodeNonKhqr(String qrCode) async {
    if (qrCode.isEmpty) return null;
    final jsonData = await methodChannel.invokeMethod('decodeNonKhqr', {
      'qrCode': qrCode,
    });
    final jsonString = jsonEncode(jsonData);
    return jsonDecode(jsonString);
  }

  @override
  Future<DeeplinkData?> generateDeepLink(DeeplinkInfo info) async {
    final jsonData = await methodChannel.invokeMethod(
      'generateDeepLink',
      jsonDecode(jsonEncode(info)),
    );
    return DeeplinkData.fromJson(jsonDecode(jsonData));
  }
}
