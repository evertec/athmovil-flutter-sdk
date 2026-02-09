import Foundation

class NewRelicConfig {

    static func sendEventToNewRelic(
    eventType: String,
    paymentStatus: String?,
    buildType: String?,
    paymentReference: String?
    ) {
        let insertKey = ConstantsUtil.nr.NR_CONSTANT.replacingOccurrences(of: "[@!$#]", with: "", options: .regularExpression)
        let url = ConstantsUtil.nr.URL_CONSTANT.replacingOccurrences(of: "[@!$#]", with: "", options: .regularExpression)
        let finalBuildType = buildType?.isEmpty ?? true ? "PROD" : buildType!

        let event: [String: Any] = [
            "eventType": eventType,
            "payment_reference": paymentReference ?? NSNull(),
            "sdk_platform": "iOS_Flutter",
            "build_type": finalBuildType,
            "payment_status": paymentStatus ?? NSNull(),
            "timestamp": Int(Date().timeIntervalSince1970 * 1000),
            "merchant_app_id":Bundle.main.infoDictionary?["CFBundleName"],
            "sdk_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "device_os_version": UIDevice.current.systemVersion,
            "device_os_model": UIDevice.current.model
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: event),
        let requestURL = URL(string: url) else {
            print("Error creating request")
            return
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue(insertKey, forHTTPHeaderField: "X-Insert-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("New Relic Event API error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Event sent to New Relic successfully")
                } else {
                    print("New Relic API response error: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}
