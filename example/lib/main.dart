import 'package:athmovil_checkout_dummy/constants/app_constants.dart';
import 'package:athmovil_checkout_dummy/view_models/items_view_model.dart';
import 'package:athmovil_checkout_dummy/view_models/payment_view_model.dart';
import 'package:athmovil_checkout_dummy/widgets/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    AppConstants(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ItemsViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => PaymentViewModel(),
          ),
        ],
        child: AppWidget(),
      ),
    ),
  );
}
