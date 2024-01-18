import '../models/user.dart';

Map<String, dynamic> userToJson(User user) {
  return {
    'phone_number': user.phoneNumber,
    'crops-en': user.cropsEn,
    'crops-hi': user.cropsHi,
    'email': user.email,
    'name': user.name,
    'address': {
      'city': user.address.city,
      'district': user.address.district,
      'street_name': user.address.streetName,
      'pincode': user.address.pincode,
    },
  };
}
