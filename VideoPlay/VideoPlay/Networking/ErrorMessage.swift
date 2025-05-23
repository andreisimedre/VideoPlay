//
//  ErrorMessage.swift
//  VideoPlay
//
//  Created by Andrei Simedre on 23.05.2025.
//

import Foundation

enum ErrorsMessage: String {
    case ERR_SERIALIZING_REQUEST = "error_serializing_request"
    case ERR_CONVERTING_TO_HTTP_RESPONSE = "error_converting_response_to_http_response"
    case ERR_PARSE_RESPONSE = "error_parsing_response"
    case ERR_NIL_BODY = "error_nil_body"
    case ERR_PARSE_ERROR_RESPONSE = "error_parsing_error_response"
    case INVALID_URL = "Invalid URL"


    var message: String {
        switch self {
        default:
            return "An error has occured. Please check your internet connection and try again"
        }
    }
}
