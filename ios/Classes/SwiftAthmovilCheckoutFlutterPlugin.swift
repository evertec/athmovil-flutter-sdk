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
        
        //TODO: remove for Prod
        lazy var urlSesion: URLSession = {
            URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
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
                let authToken = UserDefaults.standard.string(forKey:"flutter.authToken") ?? ""
                if(authToken.isEmpty){
                    // If there is a valid response, clean the ATHMPayment in PaymentResultFlag
                    PaymentResultFlag.shared.setPaymentRequest(paymentRequest: nil)
                    // Then send the response to the Flutter side
                    Self.channel?.invokeMethod(
                        ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: jsonResponse
                    )
                }else{
                    _validateIntentResponse(jsonResponse:jsonResponse, authToken:authToken)
                }
            }
            return true
        }
        
        // On Resume Event for iOS
        public func applicationDidBecomeActive(_ application: UIApplication) {
            validateCurrentPaymentInMemory()
        }
        
        public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
  
            guard let callDictionary = call.arguments as? [String: AnyObject] else {
                result(ConstantsUtil.request.ATHM_RESULT + ConstantsUtil.request.ATHM_ERROR)
                return
            }            
            let paymentJson = (callDictionary[ConstantsUtil.request.ATHM_PAYMENT] as? String) ?? ConstantsUtil.request.ATHM_EMPTY_STRING
            let publicToken = (callDictionary[ConstantsUtil.request.ATHM_PUBLIC_TOKEN] as? String) ?? ConstantsUtil.request.ATHM_DUMMY
            let paymentId = (callDictionary[ConstantsUtil.request.ATHM_PAYMENT_ID_TOKEN] as? String) ?? ConstantsUtil.request.ATHM_EMPTY_STRING
            let timeout = (callDictionary[ConstantsUtil.request.ATHM_TIMEOUT] as? Int) ?? 600
            buildType = (callDictionary[ConstantsUtil.request.ATHM_BUILD_TYPE] as? String) ?? ConstantsUtil.request.ATHM_EMPTY_STRING
           //RESET TOKEN AUTHORIZATION
           UserDefaults.standard.set("", forKey: "flutter.authToken")
           PaymentResultFlag.shared.setPaymentRequest(paymentRequest: nil)
            if publicToken == ConstantsUtil.request.ATHM_DUMMY {                
                var urlComponents = URLComponents(string: urlSelection(dummy: true))
                urlComponents?.queryItems = [URLQueryItem(name: ConstantsUtil.request.ATHM_TRANSACTION_DATA, value:paymentJson)]
                openATH(urlComponents?.url ?? URL(fileURLWithPath: ConstantsUtil.request.ATHM_EMPTY_STRING), result: result)
            } else {
                if(call.method == ConstantsUtil.call.ATHM_METHOD_OPENATHM){
                    var urlComponents = URLComponents(string: urlSelection(dummy: false))
                    urlComponents?.queryItems = [URLQueryItem(name: ConstantsUtil.request.ATHM_TRANSACTION_DATA, value:paymentJson)]
                    openATH(urlComponents?.url ?? URL(fileURLWithPath: ConstantsUtil.request.ATHM_EMPTY_STRING), result: result)
                }else if(call.method == ConstantsUtil.call.ATHM_SEND_PAYMENT) {
                    _sendPayment(paymentJson:paymentJson, timeout: timeout, result:result)
                }
            }            
             // Set the Payment Request in the Singleton
            PaymentResultFlag.shared.setPaymentRequest(paymentRequest:ATHMPayment(paymentId: paymentId, publicToken: publicToken, paymentJson:paymentJson))
            result(ConstantsUtil.request.ATHM_RESULT + ConstantsUtil.request.ATHM_EMPTY_STRING)
            
        }
        
        public func openATH(_ url: URL, result: @escaping FlutterResult) {
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

        private func _sendPayment(paymentJson: String, timeout: Int, result: @escaping FlutterResult){
            LoadingView.showLoading()
            let jsonData = Data(paymentJson.utf8)
            do {
                var paymentRequest = try JSONDecoder().decode(PaymentRequest.self, from: jsonData)
                paymentRequest.env = buildType
                paymentRequest.timeout = timeout
                let baseUrl = "https://" + baseUrlAWS
                let url = URL (string: baseUrl + ConstantsUtil.call.ATHM_API_PAYMENT)!
                var request = URLRequest(url: url, timeoutInterval: 15)
                request.httpMethod = "post"
                let body = try? JSONEncoder().encode(paymentRequest)
                let headers: [String: String] = [
                    "Content-Type": "application/json",
                    "Host": baseUrlAWS]
                request.httpBody = body
                request.allHTTPHeaderFields = headers
                urlSesion.dataTask(with: request) { (responseData, urlResponse, error) in
                    LoadingView.removeLoadign()
                    guard let responseData = responseData else {
                        Self.channel?.invokeMethod(
                            ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: ConstantsUtil.request.ATHM_ERROR)
                        return
                    }
                    let responsePayment = try? JSONDecoder().decode(PaymentResponse.self, from: responseData)
                    guard let responsePayment = responsePayment else {
                        Self.channel?.invokeMethod(
                            ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: ConstantsUtil.request.ATHM_ERROR)
                        return
                    }
                    if(responsePayment.status == "success"){
                        //SAVE AUTHTOKEN
                        let authToken = responsePayment.data?.auth_token
                        UserDefaults.standard.set(authToken, forKey: "flutter.authToken")
                        //SET PAYMENT SECURE REQUEST
                        let ecommerceId = responsePayment.data?.ecommerceId
                        let scheme = paymentRequest.callbackSchema
                        let securePayment: Any  =
                        [
                            "ecommerceId": ecommerceId ?? "",
                            "phoneNumber": paymentRequest.phoneNumber ?? "",
                            "scheme": scheme ?? "",
                            "publicToken": paymentRequest.publicToken ?? "",
                            "version": "3.0",
                            "timeout": timeout,
                            "expiresIn": timeout
                        ]
                        
                        if let theJSONData = try?  JSONSerialization.data(
                          withJSONObject: securePayment,
                          options: .prettyPrinted
                          ),
                          let securePaymentString = String(data: theJSONData,
                                                   encoding: String.Encoding.ascii) {
                            //OPEN ATHM MOVIL
                            var urlComponents = URLComponents(string: self.urlSelection(dummy: false, secure: true))
                            urlComponents?.queryItems = [URLQueryItem(name: ConstantsUtil.request.ATHM_TRANSACTION_DATA, value:securePaymentString)]
                            self.openATH(urlComponents?.url ?? URL(fileURLWithPath: ConstantsUtil.request.ATHM_EMPTY_STRING), result: result)
                        }
                    }else{
                        Self.channel?.invokeMethod(
                            ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: ConstantsUtil.request.ATHM_ERROR)
                    }
                }.resume()
            
            } catch {
                LoadingView.removeLoadign()
                Self.channel?.invokeMethod(
                    ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: ConstantsUtil.request.ATHM_ERROR
                )
            }
        }
        
        private func _validateIntentResponse(jsonResponse:String, authToken:String){         let jsonResponseData = Data(jsonResponse.utf8)
            do{
                let athmMovilPaymentResponse = try JSONDecoder().decode(ATHMovilPaymentResponse.self, from: jsonResponseData)
                if(athmMovilPaymentResponse.status == ATHMStatus.completed){
                    _authorizationPayment(jsonResponse:jsonResponse, authToken:authToken)
                }else{
                    Self.channel?.invokeMethod(
                        ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: jsonResponse
                    )
                }
            }catch{
                Self.channel?.invokeMethod(
                    ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: jsonResponse
                )
            }
        }
        
        private func _authorizationPayment(jsonResponse: String, authToken: String){
            LoadingView.showLoading()
            let jsonResponseData = Data(jsonResponse.utf8)
            do{
                var athmMovilPaymentResponse = try JSONDecoder().decode(ATHMovilPaymentResponse.self, from: jsonResponseData)
                let baseUrl = "https://" + baseUrlAWS
                let url = URL (string: baseUrl + ConstantsUtil.call.ATHM_API_AUTHORIZATION)!
                var request = URLRequest(url: url, timeoutInterval: 15)
                request.httpMethod = "post"
                let authorization = "Bearer \(authToken)"
                let headers: [String: String] = [
                    "Content-Type": "application/json",
                    "Authorization": authorization,
                    "Host": baseUrlAWS]
                request.allHTTPHeaderFields = headers
                urlSesion.dataTask(with: request) { (responseData, urlResponse, error) in
                    LoadingView.removeLoadign()
                    guard let responseData = responseData else {
                        self.failedResult(jsonResponse:jsonResponse)
                        return
                    }
                    let responseAuthorization = try? JSONDecoder().decode(AuthorizationResponse.self, from: responseData)
                    guard let responseAuthorization = responseAuthorization else{
                        self.failedResult(jsonResponse:jsonResponse)
                        return
                    }
                    //RESET TOKEN AUTHORIZATION
                    UserDefaults.standard.set("", forKey: "flutter.authToken")
                    PaymentResultFlag.shared.setPaymentRequest(paymentRequest: nil)
                    //SET PARAMS RESPONSE AUTHORIZATION
                    let dailyTransactionId = Int(responseAuthorization.data?.dailyTransactionId ?? "0") ?? 0
                    athmMovilPaymentResponse.dailyTransactionID = dailyTransactionId
                    athmMovilPaymentResponse.referenceNumber = responseAuthorization.data?.referenceNumber
                    athmMovilPaymentResponse.fee = responseAuthorization.data?.fee ?? 0.0
                    athmMovilPaymentResponse.netAmount = responseAuthorization.data?.netAmount ?? 0.0
                    do {
                        let encodedData = try JSONEncoder().encode(athmMovilPaymentResponse)
                        let paymentResult = String(data: encodedData,
                                                encoding: .utf8)
                        Self.channel?.invokeMethod(
                            ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: paymentResult
                        )
                    } catch {
                        self.failedResult(jsonResponse:jsonResponse)
                    }
                }.resume()
            }catch{
                LoadingView.removeLoadign()
                self.failedResult(jsonResponse:jsonResponse)
            }
        }
        
        private func failedResult(jsonResponse:String){
            let jsonResponseData = Data(jsonResponse.utf8)
            do{
                var athmMovilPaymentResponse = try JSONDecoder().decode(ATHMovilPaymentResponse.self, from: jsonResponseData)
                athmMovilPaymentResponse.status = .failed
                let encodedData = try JSONEncoder().encode(athmMovilPaymentResponse)
                let paymentResult = String(data: encodedData,
                                        encoding: .utf8)
                Self.channel?.invokeMethod(
                    ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: paymentResult
                )
            }catch{
                Self.channel?.invokeMethod(
                    ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: ConstantsUtil.request.ATHM_FAILED_RESULT)
            }
        }
        
        public func urlSelection(dummy: Bool, secure: Bool = false) -> String {
            switch (buildType, dummy, secure)
            {
                case (ConstantsUtil.request.ATHM_BUILD_QA, true, false):
                    return ConstantsUtil.call.ATHM_TEST_URL + ConstantsUtil.call.ATHM_MOBILE_DUMMY
                case (ConstantsUtil.request.ATHM_BUILD_QA, false, false):
                    return ConstantsUtil.call.ATHM_TEST_URL + ConstantsUtil.call.ATHM_MOBILE
                case (ConstantsUtil.request.ATHM_BUILD_QA, false, true):
                    return ConstantsUtil.call.ATHM_TEST_URL + ConstantsUtil.call.ATHM_MOBILE_SECURE
                case (ConstantsUtil.request.ATHM_BUILD_QA_CERT, true, false):
                    return ConstantsUtil.call.ATHM_TEST_URL + ConstantsUtil.call.ATHM_MOBILE_DUMMY
                case (ConstantsUtil.request.ATHM_BUILD_QA_CERT, false, false):
                    return ConstantsUtil.call.ATHM_TEST_URL + ConstantsUtil.call.ATHM_MOBILE
                case (ConstantsUtil.request.ATHM_BUILD_QA_CERT, false, true):
                    return ConstantsUtil.call.ATHM_TEST_URL + ConstantsUtil.call.ATHM_MOBILE_SECURE
                case (_, true, false):
                    return ConstantsUtil.call.ATHM_PROD_URL + ConstantsUtil.call.ATHM_MOBILE_DUMMY
                default:
                    return ConstantsUtil.call.ATHM_PROD_URL + ConstantsUtil.call.ATHM_MOBILE
                }
        }
        
        private func validateCurrentPaymentInMemory(){
            /// Get authToken
            let authToken = UserDefaults.standard.string(forKey:"flutter.authToken") ?? ""
            /// Check if the singleton has a valid payment
            let athmPayment: ATHMPayment? = PaymentResultFlag.shared.paymentRequest
            // If there is a valid athmPayment, clean the ATHMPayment in PaymentResultFlag
            PaymentResultFlag.shared.setPaymentRequest(paymentRequest: nil)
            // If its validate authToken the new flow payment secure
            if(!authToken.isEmpty){
                 return
            }else if(athmPayment == nil){
                return
            }
            // else if its the dummy case it will return always cancelled status
            else if((athmPayment?.publicToken.elementsEqual(ConstantsUtil.request.ATHM_DUMMY)) == true){
                Self.channel?.invokeMethod(
                    ConstantsUtil.call.ATHM_PAYMENT_RESULT,arguments: ConstantsUtil.request.ATHM_CANCELLED_RESULT
                )
            }else{// else its the verifyPaymentStatus services
                verifyPaymentStatus(athmPayment:athmPayment)
            }
        }
        
        private func verifyPaymentStatus(athmPayment:ATHMPayment?){
            let url = URL (string: getURL() + ConstantsUtil.call.ATHM_PAYMENT_URL)!
            var request = URLRequest(url: url, timeoutInterval: 15)
            request.httpMethod = "post"
            let paymentId = athmPayment?.paymentId ?? ""
            let publicToken = athmPayment?.publicToken ?? ""
            let consultTransaction = ConsultTransaction(publicToken: publicToken, paymentID: paymentId)
            let body = try? JSONEncoder().encode(consultTransaction)
            request.httpBody = body
            request.allHTTPHeaderFields = SwiftAthmovilCheckoutFlutterPlugin.defaultHeaders
            //TODO: URLSession.shared
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

        private func getURL() -> String {
            if buildType == ".piloto"{
                return "https://piloto.athmovil.com"
            }else if buildType == ".qa"{
                return "https://192.168.234.77:8090"
            }else if buildType == ".qacert"{
                return "https://192.168.234.77:8090"
            }
            return "https://www.athmovil.com"
        }

        private var baseUrlAWS: String {
            switch buildType {
                case ".qa":
                    return  "ozm9fx7yw5-vpce-0c7145d0436fe328e.execute-api.us-east-1.amazonaws.com"
                case ".qacert":
                    return  "gej11zn24l-vpce-009e80de2a5fcea32.execute-api.us-east-1.amazonaws.com"
                default:
                    return  "ze9tdonfjl-vpce-0dbf78eed6413b115.execute-api.us-east-1.amazonaws.com"
            }
        }
        
        struct ConsultTransaction: Encodable {
            let publicToken: String
            let paymentID: String
        }
        
        struct ResponseError: Decodable {
            let errorCode: String?
        }
    }

    //TODO: remove for Prod
    extension SwiftAthmovilCheckoutFlutterPlugin: URLSessionDelegate {
        public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            completionHandler(disposition, credential)
        }
    }
