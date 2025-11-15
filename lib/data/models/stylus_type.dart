import 'package:freezed_annotation/freezed_annotation.dart';

/// Stylus tip type enum
enum StylusType {
  @JsonValue('Conical')
  conical,
  @JsonValue('Elliptical')
  elliptical,
  @JsonValue('Microline')
  microline,
  @JsonValue('Shibata')
  shibata,
  @JsonValue('Line Contact')
  lineContact,
  @JsonValue('Other')
  other,
}

/// Cartridge type enum
enum CartridgeType {
  @JsonValue('Moving Magnet')
  movingMagnet,
  @JsonValue('Moving Coil')
  movingCoil,
  @JsonValue('Ceramic')
  ceramic,
  @JsonValue('Other')
  other,
}
