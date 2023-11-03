//
//  AppleLoginViewModel.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/29/23.
//

//import Foundation
//import UIKit
//import Alamofire
//import AuthenticationServices
//
//class AppleLoginViewModel: ObservableObject {
//    
//    @Published var showLoginView: Bool = false
//    
//    init() {
//        // Apple ID 자격 증명 상태 확인
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { [weak self] (credentialState, error) in
//            switch credentialState {
//            case .authorized:
//                DispatchQueue.main.async {
//                    self?.showLoginView = false
//                }
//            case .revoked, .notFound:
//                DispatchQueue.main.async {
//                    self?.showLoginView = true
//                }
//            default:
//                break
//            }
//        }
//    }
//}
