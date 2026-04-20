import 'package:athmovil_checkout_dummy/constants/app_constants.dart';
import 'package:athmovil_checkout_dummy/utils/local_storage_key_utils.dart';
import 'package:athmovil_checkout_dummy/view_models/payment_view_model.dart';
import 'package:athmovil_checkout_dummy/widgets/adaptive_alert_dialog_widget.dart';
import 'package:athmovil_checkout_dummy/widgets/item_settings_widget.dart';
import 'package:athmovil_checkout_dummy/widgets/simple_drop_down_widget.dart';
import 'package:athmovil_checkout_flutter/util/constants_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentSettingsPage extends StatefulWidget {
  PaymentSettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  _PaymentSettingsPageState createState() => _PaymentSettingsPageState();
}

class _PaymentSettingsPageState extends State<PaymentSettingsPage> {
  AppConstants? _constants;
  final styleItems = [Style.dark, Style.light, Style.orange];
  final langItems = [Lang.en, Lang.es];

  List<String>? environmentItems;
  final formatter = new NumberFormat("#,##0.00", "en_US");

  @override
  void didChangeDependencies() {
    Provider.of<PaymentViewModel>(context, listen: false).fetchInitialValues();
    _constants = AppConstants.of(context);
    environmentItems = [
      _constants!.productionItem,
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final verticalSpace = SizedBox(height: 16);
    return Scaffold(
      appBar: AppBar(
        title: Text(_constants!.paymentSetupLbl),
      ),
      body: Consumer<PaymentViewModel>(builder: (
        context,
        paymentViewModel,
        child,
      ) {
        if (paymentViewModel.paymentAmount == null) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    _constants!.configurationLbl.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    verticalSpace,
                    ItemSettings(
                      title: _constants!.publicToken,
                      value: paymentViewModel.businessToken ?? "",
                      onPressed: () {
                        _updateValue(
                          title: _constants!.changeToken,
                          description: _constants!.changeTokenDescription,
                          hint: _constants!.publicToken,
                          valueId: PUBLIC_TOKEN_PREF_KEY,
                        );
                      },
                    ),
                    ItemSettings(
                      title: _constants!.timeout,
                      value: "${paymentViewModel.timeout} seconds",
                      onPressed: () {
                        _updateValue(
                          title: _constants!.changeTimeout,
                          description: _constants!.changeTimeoutDescription,
                          hint: _constants!.timeout,
                          isNumber: true,
                          valueId: TIMEOUT_PREF_KEY,
                        );
                      },
                    ),
                    ItemSettings(
                      title: _constants!.paymentAmountLbl,
                      value:
                          "\$${formatter.format(paymentViewModel.paymentAmount)}",
                      onPressed: () {
                        _updateValue(
                          title: _constants!.changeTotal,
                          description: _constants!.changeTotalDescription,
                          hint: _constants!.paymentAmountLbl,
                          isNumber: true,
                          isCurrency: true,
                          valueId: PAYMENT_AMOUNT_PREF_KEY,
                        );
                      },
                    ),
                    //Divider(),
                    /*
                    ItemSettings(
                      title: _constants!.themeLbl,
                      dropDown: SimpleDropDown(
                        onChanged: (value) {
                          Provider.of<PaymentViewModel>(
                            context,
                            listen: false,
                          ).setPaymentValue(
                            valueId: THEME_PREF_KEY,
                            value: value.toString(),
                            dynamicValue: value,
                          );
                        },
                        value: paymentViewModel.style,
                        items: styleItems,
                      ),
                    ),
                    */
                    ItemSettings(
                      title: _constants!.environmentLbl,
                      dropDown: SimpleDropDown(
                        onChanged: (value) {
                          Provider.of<PaymentViewModel>(
                            context,
                            listen: false,
                          ).setPaymentValue(
                            valueId: BUILD_TYPE_PREF_KEY,
                            value: value.toString(),
                          );
                        },
                        value: paymentViewModel.environment,
                        items: environmentItems,
                      ),
                    ),
                    /*
                    ItemSettings(
                      title: _constants!.languageLbl,
                      dropDown: SimpleDropDown(
                        onChanged: (value) {
                          Provider.of<PaymentViewModel>(
                            context,
                            listen: false,
                          ).setPaymentValue(
                            valueId: LANGUAGE_PREF_KEY,
                            value: value.toString(),
                            dynamicValue: value,
                          );
                        },
                        value: paymentViewModel.lang,
                        items: langItems,
                      ),
                    ),
                    */
                  ],
                ),
              ),
              verticalSpace,
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  _constants!.paymentDescriptionLbl,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    _constants!.optionalLbl.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    verticalSpace,
                    ItemSettings(
                      title: _constants!.subtotal,
                      value: "\$${formatter.format(paymentViewModel.subtotal)}",
                      onPressed: () {
                        _updateValue(
                          title: _constants!.changeSubTotal,
                          description: _constants!.changeSubTotalDescription,
                          hint: _constants!.subtotal,
                          isNumber: true,
                          isCurrency: true,
                          valueId: SUBTOTAL_PREF_KEY,
                        );
                      },
                    ),
                    ItemSettings(
                      title: _constants!.tax,
                      value: "\$${formatter.format(paymentViewModel.tax)}",
                      onPressed: () {
                        _updateValue(
                          title: _constants!.changeTax,
                          description: _constants!.changeTaxDescription,
                          hint: _constants!.tax,
                          isNumber: true,
                          isCurrency: true,
                          valueId: TAX_PREF_KEY,
                        );
                      },
                    ),
                    ItemSettings(
                      title: _constants!.metadata1,
                      value: paymentViewModel.metadata1 != null
                          ? paymentViewModel.metadata1
                          : "",
                      onPressed: () {
                        _updateValue(
                          title: _constants!.changeMetadata1,
                          description: _constants!.changeMetadata1Description,
                          hint: _constants!.metadata1,
                          valueId: METADATA1_PREF_KEY,
                        );
                      },
                    ),
                    ItemSettings(
                      title: _constants!.metadata2,
                      value: paymentViewModel.metadata2 != null
                          ? paymentViewModel.metadata2
                          : "",
                      onPressed: () {
                        _updateValue(
                          title: _constants!.changeMetadata2,
                          description: _constants!.changeMetadata2Description,
                          hint: _constants!.metadata2,
                          valueId: METADATA2_PREF_KEY,
                        );
                      },
                    ),
                    //PHONE NUMBER
                    ItemSettings(
                      title: _constants!.phoneNumber,
                      value: paymentViewModel.phoneNumber != null
                          ? paymentViewModel.phoneNumber
                          : "",
                      onPressed: () {
                        _updateValue(
                          title: _constants!.changePhoneNumber,
                          description:
                              _constants!.changePhoneNumberDescription,
                          hint: _constants!.phoneNumber,
                          valueId: PHONE_NUMBER_PREF_KEY,
                        );
                      },
                    ),
                    verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _updateValue({
    String? title,
    String? description,
    String? hint,
    bool isNumber = false,
    bool isCurrency = false,
    required String valueId,
  }) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AdaptiveAlertDialog(
          title: title,
          cancelButtonText: AppConstants.of(context)!.cancelLbl,
          okButtonText: AppConstants.of(context)!.okLbl,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                description!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Form(
                key: formKey,
                child: Material(
                  child: TextFormField(
                    keyboardType:
                        isNumber ? TextInputType.text : TextInputType.text,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: 15,
                        bottom: 11,
                        top: 11,
                        right: 15,
                      ),
                      hintText: hint,
                    ),
                    onSaved: (value) {
                      Provider.of<PaymentViewModel>(
                        context,
                        listen: false,
                      ).setPaymentValue(
                        valueId: valueId,
                        value: value,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          okButtonCallback: () {
            formKey.currentState!.save();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
