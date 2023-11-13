## 0.0.1

* TODO: Describe initial release.

## 0.0.2

* Update dependencies flutter
```dart
dependencies:
  async: ^2.6.1
  uuid: 3.0.4
  intl: ^0.18.1
```

* New ATHMovilPaymentSecureButton:
```dart
ATHMovilPaymentSecureButton(style: Style.orange,
                      lang: Lang.en,
                      athMovilPayment: ATHMovilPayment(), //ATHMovilPayment
                      listener: this,) //ATHMovilPaymentResponseListener
```

* New ATHMovilPayment:
```dart
ATHMovilPayment(
    businessToken: , 
    callbackSchema: ,
    total: ,
    subtotal: , 
    tax: , 
    timeout: , 
    metadata1: ,
    metadata2: ,
    items: , 
    phoneNumber: , //Add this param Phone number of customer is optional
);
```

* New Handle response method:
```dart
@override
  void onFailedPayment(ATHMovilPaymentResponse athMovilPaymentResponse) {
    //Handle response faild transaction
  }
```