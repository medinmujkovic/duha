import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Konverter za Firebase Timestamp -> DateTime
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic timestamp) {
    if (timestamp == null) {
      throw ArgumentError('Timestamp cannot be null');
    }
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    throw ArgumentError('Invalid timestamp format: ${timestamp.runtimeType}');
  }

  @override
  dynamic toJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}

/// Konverter za nullable DateTime
class NullableTimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  @override
  dynamic toJson(DateTime? dateTime) {
    return dateTime != null ? Timestamp.fromDate(dateTime) : null;
  }
}

/// Konverter za enum -> String (opciono, ali korisno)
class EnumConverter<T extends Enum> implements JsonConverter<T, String> {
  final List<T> values;
  
  const EnumConverter(this.values);

  @override
  T fromJson(String json) {
    return values.firstWhere(
      (e) => e.name == json,
      orElse: () => throw ArgumentError('Unknown enum value: $json'),
    );
  }

  @override
  String toJson(T object) => object.name;
}