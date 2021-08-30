import 'package:athmovil_checkout_flutter/interfaces/athmovil_payment_response_listener.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_payment.dart';
import 'package:athmovil_checkout_flutter/open_athmovil.dart';
import 'package:athmovil_checkout_flutter/util/constants_util.dart';
import 'package:flutter/material.dart';

enum Style { orange, light, dark }
enum Lang { en, es }

class ATHMovilPaymentButton extends StatelessWidget {
  final Style? style;
  final Lang? lang;
  final String? buildType;
  final ATHMovilPaymentResponseListener listener;
  final ATHMovilPayment athMovilPayment;

  ATHMovilPaymentButton({
    Key? key,
    this.style,
    this.lang,
    this.buildType,
    required this.listener,
    required this.athMovilPayment,
  }) : super(key: key);

  // TODO discuss with David about validate the athMovilPayment (Null Safety or Assert for dev mode)

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final res = await AthmovilCheckoutFlutter.openATHMovil(
          athMovilPayment: athMovilPayment,
          buildType: buildType,
          athMovilPaymentResponseListener: listener,
        );
      },
      style: ElevatedButton.styleFrom(
        primary: getBackgroundColorButton(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: _ATHMovilTextButton(
          style: style,
          lang: lang,
        ),
      ),
    );
  }

  Color getBackgroundColorButton() {
    switch (style) {
      case Style.dark:
        return ConstantsUtil.ATHM_DARK_COLOR;
      case Style.light:
        return ConstantsUtil.ATHM_LIGHT_COLOR;
      default:
        return ConstantsUtil.ATHM_DEFAULT_COLOR;
    }
  }
}

class _ATHMovilTextButton extends StatelessWidget {
  final Style? style;
  final Lang? lang;

  _ATHMovilTextButton({
    Key? key,
    this.style,
    this.lang,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textImageButton = ConstantsUtil.ATHM_ASSETS + getTextImageButton();
    const leftRightSpace = Expanded(flex: 1, child: SizedBox.shrink());

    return Row(
      children: [
        leftRightSpace,
        Expanded(
          flex: 3,
          child: Image(
            image: AssetImage(
              textImageButton,
              package: ConstantsUtil.ATHM_PACKAGE_NAME,
            ),
            fit: BoxFit.contain,
          ),
        ),
        leftRightSpace,
      ],
    );
  }

  String getTextImageButton() {
    switch (style) {
      case Style.light:
        if (lang == Lang.es) {
          return ConstantsUtil.ATHM_TXT_BTN_BLACK_ES;
        } else {
          return ConstantsUtil.ATHM_TXT_BTN_BLACK;
        }
      default:
        if (lang == Lang.es) {
          return ConstantsUtil.ATHM_TXT_BTN_WHITE_ES;
        } else {
          return ConstantsUtil.ATHM_TXT_BTN_WHITE;
        }
    }
  }
}
