//
//  FirAuthErrorHandling.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 2/6/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .invalidEmail:
            return " Invalid email punctuation "
        case .networkError:
            return " Poor network connection "
        case .wrongPassword:
            return " Invalid name or password "
        case .internalError:
            return "Internal error, try again later "
        case .missingEmail:
            return " Missing email "
        case .invalidCredential:
            return "Invalid Credential "
        case .invalidRecipientEmail:
            return " Invalid email "
        case .emailAlreadyInUse:
            return "Email already in use"
        case .userNotFound:
            return " No such user "
        case .credentialAlreadyInUse:
            return " Credential already in use "
        case .tooManyRequests:
            return "Too many request, try later"
        case .weakPassword:
            return " Weak password "
        default:
            return "Unknown error occurred"
        }
    }
}
