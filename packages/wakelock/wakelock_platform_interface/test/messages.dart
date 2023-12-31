// Autogenerated from Pigeon (v1.0.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import
// @dart = 2.12
import 'dart:async';
import 'dart:typed_data' show Uint8List, Int32List, Int64List, Float64List;
import 'package:flutter/foundation.dart' show WriteBuffer, ReadBuffer;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wakelock_platform_interface/messages.dart';

class _TestWakelockApiCodec extends StandardMessageCodec {
  const _TestWakelockApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is IsEnabledMessage) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is ToggleMessage) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return IsEnabledMessage.decode(readValue(buffer)!);

      case 129:
        return ToggleMessage.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class TestWakelockApi {
  static const MessageCodec<Object?> codec = _TestWakelockApiCodec();

  void toggle(ToggleMessage msg);
  IsEnabledMessage isEnabled();
  static void setup(TestWakelockApi? api) {
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.WakelockApi.toggle', codec);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.WakelockApi.toggle was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ToggleMessage? arg_msg = args[0] as ToggleMessage?;
          assert(arg_msg != null,
              'Argument for dev.flutter.pigeon.WakelockApi.toggle was null, expected non-null ToggleMessage.');
          api.toggle(arg_msg!);
          return <Object?, Object?>{};
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.WakelockApi.isEnabled', codec);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          // ignore message
          final IsEnabledMessage output = api.isEnabled();
          return <Object?, Object?>{'result': output};
        });
      }
    }
  }
}
