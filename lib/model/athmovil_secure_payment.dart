class ATHMSecurePayment {
  ATHMSecurePayment({
    required this.phoneNumber,
    required this.ecommerceId,
    required this.scheme,
    required this.publicToken,
    this.version,
  });

  final String? phoneNumber;
  final String? ecommerceId;
  final String? scheme;
  final String? publicToken;
  final String? version;

  factory ATHMSecurePayment.fromMap(Map<String, dynamic> data) {
    return ATHMSecurePayment(
      phoneNumber: data['phoneNumber'],
      ecommerceId: data['ecommerceId'],
      scheme: data['scheme'],
      publicToken: data['publicToken'],
      version: data['version'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'ecommerceId': ecommerceId,
      'scheme': scheme,
      'publicToken': publicToken,
      'version': version,
    };
  }

  Map toJson() => {
        'phoneNumber': phoneNumber,
        'ecommerceId': ecommerceId,
        'scheme': scheme,
        'publicToken': publicToken,
        'version': version,
      };
}
