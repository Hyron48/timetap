import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String street;
  final String city;
  final String county;
  final String country;

  AddressModel({
    required this.street,
    required this.city,
    required this.county,
    required this.country,
  });

  static AddressModel empty = AddressModel(
    street: '',
    city: '',
    county: '',
    country: '',
  );

  bool get isEmpty => this == AddressModel.empty;

  @override
  List<Object?> get props => [street, city, county, country];
}
