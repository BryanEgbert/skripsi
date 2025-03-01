// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_daycare.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetDaycareImpl _$$PetDaycareImplFromJson(Map<String, dynamic> json) =>
    _$PetDaycareImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      distance: (json['distance'] as num).toDouble(),
      profileImage: json['profileImage'] as String,
      averageRating: (json['averageRating'] as num).toDouble(),
      ratingCount: (json['ratingCount'] as num).toInt(),
      bookedNum: (json['bookedNum'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
    );

Map<String, dynamic> _$$PetDaycareImplToJson(_$PetDaycareImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'distance': instance.distance,
      'profileImage': instance.profileImage,
      'averageRating': instance.averageRating,
      'ratingCount': instance.ratingCount,
      'bookedNum': instance.bookedNum,
      'price': instance.price,
      'thumbnail': instance.thumbnail,
    };

_$PetDaycareDetailsImpl _$$PetDaycareDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$PetDaycareDetailsImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      distance: (json['distance'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      pricingType: json['pricingType'] as String,
      description: json['description'] as String,
      bookedNum: (json['bookedNum'] as num).toInt(),
      averageRating: (json['averageRating'] as num).toDouble(),
      ratingCount: (json['ratingCount'] as num).toInt(),
      hasPickupService: json['hasPickupService'] as bool,
      mustBeVaccinated: json['mustBeVaccinated'] as bool,
      groomingAvailable: json['groomingAvailable'] as bool,
      foodProvided: json['foodProvided'] as bool,
      foodBrand: json['foodBrand'] as String,
      createdAt: json['createdAt'] as String,
      owner: User.fromJson(json['owner'] as Map<String, dynamic>),
      dailyWalks: Lookup.fromJson(json['dailyWalks'] as Map<String, dynamic>),
      dailyPlaytime:
          Lookup.fromJson(json['dailyPlaytime'] as Map<String, dynamic>),
      thumbnailUrls: (json['thumbnailUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$PetDaycareDetailsImplToJson(
        _$PetDaycareDetailsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'distance': instance.distance,
      'price': instance.price,
      'pricingType': instance.pricingType,
      'description': instance.description,
      'bookedNum': instance.bookedNum,
      'averageRating': instance.averageRating,
      'ratingCount': instance.ratingCount,
      'hasPickupService': instance.hasPickupService,
      'mustBeVaccinated': instance.mustBeVaccinated,
      'groomingAvailable': instance.groomingAvailable,
      'foodProvided': instance.foodProvided,
      'foodBrand': instance.foodBrand,
      'createdAt': instance.createdAt,
      'owner': instance.owner,
      'dailyWalks': instance.dailyWalks,
      'dailyPlaytime': instance.dailyPlaytime,
      'thumbnailUrls': instance.thumbnailUrls,
    };
