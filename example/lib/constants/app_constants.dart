import 'package:flutter/material.dart';

class AppConstants extends InheritedWidget {
  static AppConstants? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppConstants>();

  const AppConstants({required Widget child, Key? key})
      : super(key: key, child: child);

  // General labels
  final String appName = "ATH Movil Checkout Dummy";
  final String goToCartLbl = "GO TO CART";
  final String addLbl = "Add";
  final String addDefaultLbl = "Add Default";
  final String cancelLbl = "Cancel";
  final String okLbl = "OK";

  // Item Labels
  final String itemsLbl = "Items";
  final String addItemLbl = "Add Item";
  final String nameLbl = "Name";
  final String descriptionLbl = "Description";
  final String priceLbl = "Price";
  final String quantityLbl = "Quantity";
  final String metadataLbl = "Metadata";

  // Payment Configuration Labels
  final String paymentSetupLbl = "Payment Configuration";
  final String configurationLbl = "Configuration";
  final String publicToken = "Public Token";
  final String timeout = "Timeout";
  final String paymentAmountLbl = "Payment Amount";
  final String totalLbl = "Total";
  final String themeLbl = "Theme";
  final String environmentLbl = "Environment";
  final String languageLbl = "Language";


  // Environment Items
  final String environmentItem = "Environment";
  final String productionItem = "Production";

  //final String callbackSchema = "Callback Schema";
  final String paymentDescriptionLbl =
      "Payment will be sent to the account of the provided Public Token for the provided Payment Amount";
  final String optionalLbl = "Optional Parameters";
  final String subtotal = "Subtotal";
  final String tax = "Tax";
  final String metadata1 = "Metadata1";
  final String metadata2 = "Metadata2";
  final String phoneNumber = "Phone Number";

  //  Payment Configuration Dialog Labels
  final String changeToken = "Change Public Token";
  final String changeTokenDescription =
      "Provide the token of the account that will receive the payment.";

  final String changeTimeout = "Change Timeout";
  final String changeTimeoutDescription =
      "Provide a Timeout value for the payment process in seconds.";

  final String changeTotal = "Change Payment Amount";
  final String changeTotalDescription =
      "Provide the amount to process the payment for.";

  final String changeSubTotal = "Change Payment SubTotal";
  final String changeSubTotalDescription =
      "Provide the subTotal to process the payment for.";

  final String changeTax = "Change Payment Tax";
  final String changeTaxDescription =
      "Provide the tax to process the payment for.";

  final String changeMetadata1 = "Change Payment Metadata1";
  final String changeMetadata1Description =
      "Provide the metadata1 to process the payment for.";

  final String changeMetadata2 = "Change Payment Metadata2";
  final String changeMetadata2Description =
      "Provide the metadata2 to process the payment for.";

  // Cart Labels
  final String cartLbl = "Cart";
  final String otherPaymentMethodLbl = "Other Payment Method";

  final String changePhoneNumber = "Change phone number";
  final String changePhoneNumberDescription =
      "Provide the phone number to process the payment for.";

  @override
  bool updateShouldNotify(AppConstants oldWidget) => false;
}
