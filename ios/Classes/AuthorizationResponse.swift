//
//  AuthorizationResponse.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 15/09/22.
//  Copyright © 2022 Evertec. All rights reserved.
//

import Foundation

struct AuthorizationResponse: Codable {
    let status: ATHMStatus?
    let data: PaymentData?
    let message: String?
}

struct PaymentData: Codable {
    let dailyTransactionId: String?
    let referenceNumber: String?
    let fee: Double?
    let netAmount: Double?
}

enum ATHMStatus: String, Codable {
    case success,
    error,
    completed,
    cancelled,
    expired,
    failed
}
