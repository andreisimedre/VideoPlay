//
//  HTTPURLResponse + Extension.swift
//  VideoPlay
//
//  Created by Andrei Simedre on 23.05.2025.
//

import Foundation

extension HTTPURLResponse {
    func isSuccessful() -> Bool {
        return statusCode >= 200 && statusCode <= 299
    }
}
