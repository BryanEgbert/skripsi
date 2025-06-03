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
      locality: json['locality'] as String,
      averageRating: (json['averageRating'] as num).toDouble(),
      ratingCount: (json['ratingCount'] as num).toInt(),
      bookedNum: (json['bookedNum'] as num).toInt(),
      prices: (json['prices'] as List<dynamic>)
          .map((e) => Price.fromJson(e as Map<String, dynamic>))
          .toList(),
      thumbnail: json['thumbnail'] as String,
    );

Map<String, dynamic> _$$PetDaycareImplToJson(_$PetDaycareImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'distance': instance.distance,
      'locality': instance.locality,
      'averageRating': instance.averageRating,
      'ratingCount': instance.ratingCount,
      'bookedNum': instance.bookedNum,
      'prices': instance.prices,
      'thumbnail': instance.thumbnail,
    };

_$PetDaycareDetailsImpl _$$PetDaycareDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$PetDaycareDetailsImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      locality: json['locality'] as String,
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      openingHour: json['openingHour'] as String,
      closingHour: json['closingHour'] as String,
      distance: (json['distance'] as num).toDouble(),
      pricings: (json['pricings'] as List<dynamic>)
          .map((e) => Price.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'locality': instance.locality,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'openingHour': instance.openingHour,
      'closingHour': instance.closingHour,
      'distance': instance.distance,
      'pricings': instance.pricings,
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

_$PriceImpl _$$PriceImplFromJson(Map<String, dynamic> json) => _$PriceImpl(
      petCategory:
          PetCategory.fromJson(json['petCategory'] as Map<String, dynamic>),
      price: (json['price'] as num).toDouble(),
      pricingType: Lookup.fromJson(json['pricingType'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PriceImplToJson(_$PriceImpl instance) =>
    <String, dynamic>{
      'petCategory': instance.petCategory,
      'price': instance.price,
      'pricingType': instance.pricingType,
    };
