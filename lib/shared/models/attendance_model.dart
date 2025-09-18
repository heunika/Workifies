import 'package:equatable/equatable.dart';

class AttendanceModel extends Equatable {
  final String id;
  final String userId;
  final String companyId;
  final DateTime clockInTime;
  final DateTime? clockOutTime;
  final Duration? totalHours;
  final String? notes;
  final double? clockInLatitude;
  final double? clockInLongitude;
  final double? clockOutLatitude;
  final double? clockOutLongitude;
  final String? clockInAddress;
  final String? clockOutAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AttendanceModel({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.clockInTime,
    this.clockOutTime,
    this.totalHours,
    this.notes,
    this.clockInLatitude,
    this.clockInLongitude,
    this.clockOutLatitude,
    this.clockOutLongitude,
    this.clockInAddress,
    this.clockOutAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      companyId: json['companyId'] as String,
      clockInTime: DateTime.parse(json['clockInTime'] as String),
      clockOutTime: json['clockOutTime'] != null
          ? DateTime.parse(json['clockOutTime'] as String)
          : null,
      totalHours: json['totalHours'] != null
          ? Duration(microseconds: json['totalHours'] as int)
          : null,
      notes: json['notes'] as String?,
      clockInLatitude: json['clockInLatitude'] as double?,
      clockInLongitude: json['clockInLongitude'] as double?,
      clockOutLatitude: json['clockOutLatitude'] as double?,
      clockOutLongitude: json['clockOutLongitude'] as double?,
      clockInAddress: json['clockInAddress'] as String?,
      clockOutAddress: json['clockOutAddress'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'companyId': companyId,
      'clockInTime': clockInTime.toIso8601String(),
      'clockOutTime': clockOutTime?.toIso8601String(),
      'totalHours': totalHours?.inMicroseconds,
      'notes': notes,
      'clockInLatitude': clockInLatitude,
      'clockInLongitude': clockInLongitude,
      'clockOutLatitude': clockOutLatitude,
      'clockOutLongitude': clockOutLongitude,
      'clockInAddress': clockInAddress,
      'clockOutAddress': clockOutAddress,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AttendanceModel copyWith({
    String? id,
    String? userId,
    String? companyId,
    DateTime? clockInTime,
    DateTime? clockOutTime,
    Duration? totalHours,
    String? notes,
    double? clockInLatitude,
    double? clockInLongitude,
    double? clockOutLatitude,
    double? clockOutLongitude,
    String? clockInAddress,
    String? clockOutAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      companyId: companyId ?? this.companyId,
      clockInTime: clockInTime ?? this.clockInTime,
      clockOutTime: clockOutTime ?? this.clockOutTime,
      totalHours: totalHours ?? this.totalHours,
      notes: notes ?? this.notes,
      clockInLatitude: clockInLatitude ?? this.clockInLatitude,
      clockInLongitude: clockInLongitude ?? this.clockInLongitude,
      clockOutLatitude: clockOutLatitude ?? this.clockOutLatitude,
      clockOutLongitude: clockOutLongitude ?? this.clockOutLongitude,
      clockInAddress: clockInAddress ?? this.clockInAddress,
      clockOutAddress: clockOutAddress ?? this.clockOutAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => clockOutTime == null;

  @override
  List<Object?> get props => [
        id,
        userId,
        companyId,
        clockInTime,
        clockOutTime,
        totalHours,
        notes,
        clockInLatitude,
        clockInLongitude,
        clockOutLatitude,
        clockOutLongitude,
        clockInAddress,
        clockOutAddress,
        createdAt,
        updatedAt,
      ];
}