    import Flutter
    import UIKit

    public class SwiftAthmovilCheckoutFlutterPlugin: NSObject, FlutterPlugin {
        
        static var channel: FlutterMethodChannel? = nil
        var buildType: String = ""
        static let defaultHeaders: [String: String] = {

                let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

                let currentLanguaje = Locale.current.languageCode ?? ""

                let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""

                

                let headers: [String: String] = ["Accept": "application/json",

                                                   "Content-Type": "application/json",

                                                   "agentType": "ios",

                                                   "athm_version": currentVersion,

                                                   "Accept-Language": currentLanguaje,

                                                   "operatingSystem": "iOS \(UIDevice.current.systemVersion)",

                                                   "Content-Encoding": "gzip",

                                                   "manufacturer" : "Apple",

                                                   "deviceID": deviceId]

                

                return headers

            }()
        
    
        lazy var urlSesion: URLSession = {
            URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue())
        }()
        
        public static func register(with registrar: FlutterPluginRegistrar) {
            let channel = FlutterMethodChannel(name: ConstantsUtil.call.ATHM_CHANNEL_NAME, binaryMessenger: registrar.messenger())
            Self.channel = channel
            let instance = SwiftAthmovilCheckoutFlutterPlugin()
            registrar.addMethodCallDelegate(instance, channel: channel)
            registrar.addApplicationDelegate(instance)
        }
        
        // On Response Event for iOS
        public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let queryItemATHM = urlComponents?.queryItems?.first(where: { queryItem -> Bool in
                return queryItem.name == ConstantsUtil.request.ATHM_RETURN_DATA
            })
            let jsonResponse = queryItemATHM?.value ?? ""
            if jsonResponse != "" && Self.channel != nil {
                // If there is a valid response, clean the ATHMPayment in PaymentResultFlag
                PaymentResultFlag.shared.setPaymentRequest(paymentRequest: nil)
                // Then send the response to the Flutter side
                Self.channel?.invokeMethod(
                    ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: jsonResponse
                )
            }
            return true
        }
        
        // On Resume Event for iOS
        public func applicationDidBecomeActive(_ application: UIApplication) {
            validateCurrentPaymentInMemory()
        }
        
        public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
            guard let callDictionary = call.arguments as? [String: AnyObject], call.method == ConstantsUtil.call.ATHM_METHOD_OPENATHM else {
                result(ConstantsUtil.request.ATHM_RESULT + ConstantsUtil.request.ATHM_ERROR)
                return
            }
            
            let paymentJson = (callDictionary[ConstantsUtil.request.ATHM_PAYMENT] as? String) ?? ConstantsUtil.request.ATHM_EMPTY_STRING
            let publicToken = (callDictionary[ConstantsUtil.request.ATHM_PUBLIC_TOKEN] as? String) ?? ConstantsUtil.request.ATHM_DUMMY
            let paymentId = (callDictionary[ConstantsUtil.request.ATHM_PAYMENT_ID_TOKEN] as? String) ?? ConstantsUtil.request.ATHM_EMPTY_STRING
            
            buildType = (callDictionary[ConstantsUtil.request.ATHM_BUILD_TYPE] as? String) ?? ConstantsUtil.request.ATHM_EMPTY_STRING
            if publicToken == ConstantsUtil.request.ATHM_DUMMY {
                
                var urlComponents = URLComponents(string: urlSelection(buildType, dummy: true))
                urlComponents?.queryItems = [URLQueryItem(name: ConstantsUtil.request.ATHM_TRANSACTION_DATA, value:paymentJson)]
                openATH(urlComponents?.url ?? URL(fileURLWithPath: ConstantsUtil.request.ATHM_EMPTY_STRING), result: result, buildType: buildType)
                
            } else {
                var urlComponents = URLComponents(string: urlSelection(buildType, dummy: false))
                urlComponents?.queryItems = [URLQueryItem(name: ConstantsUtil.request.ATHM_TRANSACTION_DATA, value:paymentJson)]
                openATH(urlComponents?.url ?? URL(fileURLWithPath: ConstantsUtil.request.ATHM_EMPTY_STRING), result: result, buildType: buildType)
            }
            
            // Set the Payment Request in the Singleton
            PaymentResultFlag.shared.setPaymentRequest(paymentRequest:ATHMPayment(paymentId: paymentId, publicToken: publicToken, paymentJson:paymentJson))
            
            result(ConstantsUtil.request.ATHM_RESULT + ConstantsUtil.request.ATHM_EMPTY_STRING)
        }
        
        public func openATH(_ url: URL, result: @escaping FlutterResult, buildType: String) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options:[UIApplication.OpenExternalURLOptionsKey.universalLinksOnly:  true]) {  success in
                    if success {
                        result(ConstantsUtil.request.ATHM_RESULT + ConstantsUtil.request.ATHM_SUCCESS)
                    } else {
                        UIApplication.shared.open(URL(string: ConstantsUtil.request.ATHM_APPSTORE_URL)!, options: [:]) { success in
                            result(ConstantsUtil.request.ATHM_RESULT + ConstantsUtil.request.ATHM_APPSTORE)
                        }
                    }
                }
            }
        }
        
        public func urlSelection(_ buildType: String, dummy: Bool) -> String {
            
            switch (buildType, dummy)
            {
                case (ConstantsUtil.request.ATHM_BUILD_QA, true):
                    return ConstantsUtil.call.ATHM_TEST_URL + ConstantsUtil.call.ATHM_MOBILE_DUMMY
            case (ConstantsUtil.request.ATHM_BUILD_QA, false):
                return ConstantsUtil.call.ATHM_TEST_URL + ConstantsUtil.call.ATHM_MOBILE
            case (_, true):
                return ConstantsUtil.call.ATHM_PROD_URL + ConstantsUtil.call.ATHM_MOBILE_DUMMY
            default:
                    return ConstantsUtil.call.ATHM_PROD_URL + ConstantsUtil.call.ATHM_MOBILE
            }
        }
        
        private func validateCurrentPaymentInMemory(){
            /// Check if the singleton has a valid payment
            let athmPayment: ATHMPayment? = PaymentResultFlag.shared.paymentRequest
            
            if athmPayment != nil {
                // If there is a valid athmPayment, clean the ATHMPayment in PaymentResultFlag
                PaymentResultFlag.shared.setPaymentRequest(paymentRequest: nil)
                
                if((athmPayment?.publicToken.elementsEqual(ConstantsUtil.request.ATHM_DUMMY)) == true){
                    Self.channel?.invokeMethod(
                        ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: ConstantsUtil.request.ATHM_CANCELLED_RESULT
                    )
                }else{
                    let url = URL (string: getURL() + ConstantsUtil.call.ATHM_PAYMENT_URL)!
                    var request = URLRequest(url: url, timeoutInterval: 15)
                    request.httpMethod = "post"
                    let paymentId = athmPayment?.paymentId ?? ""
                    let publicToken = athmPayment?.publicToken ?? ""
                    let consultTransaction = ConsultTransaction(publicToken: publicToken, paymentID: paymentId)
                    let body = try? JSONEncoder().encode(consultTransaction)
                    request.httpBody = body
                    request.allHTTPHeaderFields = SwiftAthmovilCheckoutFlutterPlugin.defaultHeaders
                    urlSesion.dataTask(with: request) { (responseData, urlResponse, error) in
                        guard let responseData = responseData else {
                            Self.channel?.invokeMethod(
                                ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: ConstantsUtil.request.ATHM_ERROR)
                            return
                        }
                        let responseError = try? JSONDecoder().decode(ResponseError.self, from: responseData)
                        if responseError != nil && responseError?.errorCode != nil {
                            Self.channel?.invokeMethod(
                                ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: ConstantsUtil.request.ATHM_CANCELLED_RESULT)
                            return
                        }
                        let responseString = String(data: responseData, encoding: .utf8)
                        Self.channel?.invokeMethod(
                            ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: responseString)
                    }.resume()
                }
            }
        }
        
        private func getURL() -> String {
            return "https://www.athmovil.com"
        }
        
        struct ConsultTransaction: Encodable {
            let publicToken: String
            let paymentID: String
        }
        
        struct ResponseError: Decodable {
            let errorCode: String?
        }
    }
