#import "AthmovilCheckoutFlutterPlugin.h"
#if __has_include(<athmovil_checkout_flutter/athmovil_checkout_flutter-Swift.h>)
#import <athmovil_checkout_flutter/athmovil_checkout_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "athmovil_checkout_flutter-Swift.h"
#endif

@implementation AthmovilCheckoutFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAthmovilCheckoutFlutterPlugin registerWithRegistrar:registrar];
}
@end
