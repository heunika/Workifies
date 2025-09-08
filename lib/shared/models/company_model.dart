import 'package:equatable/equatable.dart';

class CompanyModel extends Equatable {
  final String id;
  final String name;
  final String? logoUrl;
  final String industry;
  final int yearFounded;
  final String companyCode;
  final String managerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CompanyModel({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.industry,
    required this.yearFounded,
    required this.companyCode,
    required this.managerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
      industry: json['industry'] as String,
      yearFounded: json['yearFounded'] as int,
      companyCode: json['companyCode'] as String,
      managerId: json['managerId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'industry': industry,
      'yearFounded': yearFounded,
      'companyCode': companyCode,
      'managerId': managerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CompanyModel copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? industry,
    int? yearFounded,
    String? companyCode,
    String? managerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      industry: industry ?? this.industry,
      yearFounded: yearFounded ?? this.yearFounded,
      companyCode: companyCode ?? this.companyCode,
      managerId: managerId ?? this.managerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        logoUrl,
        industry,
        yearFounded,
        companyCode,
        managerId,
        createdAt,
        updatedAt,
      ];
}