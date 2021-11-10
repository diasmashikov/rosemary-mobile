import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';

part 'shipping_address_state.dart';

class ShippingAddressCubit extends Cubit<ShippingAddressState> {
  final Repository repository;

  ShippingAddressCubit({required this.repository})
      : super(ShippingAddressInitial());

  Future<void> postShippingAddress(
      {required String country,
      required String region,
      required String city,
      required String zip,
      required String address,
      required String homeNumber, User? user, String? token}) async {
    repository.putShippingAddress(country: country, region: region, city: city, zip: zip, address: address, homeNumber: homeNumber, user: user, token: token);
  }
}
