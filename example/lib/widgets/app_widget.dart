import 'package:athmovil_checkout_dummy/pages/cart/cart_page.dart';
import 'package:athmovil_checkout_dummy/pages/items/items_page.dart';
import 'package:athmovil_checkout_dummy/pages/items/widgets/item_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:athmovil_checkout_flutter/generated/l10n.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        hintColor: Colors.black,
        primaryColorDark: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ItemsPage(),
        '/item-form': (context) => ItemFormPage(),
        '/cart': (context) => CartPage(),
      },
    );
  }
}
