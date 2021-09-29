//
//  UinstallTracker.swift
//
//  Created by Radzivon Bartoshyk on 29.09.21.
//

import Foundation
import Combine
import Alamofire

public class UinstallTracker {
    private let applicationToken: String
    private let appPrefix: String
    private let amplitudeUserId: String
    private let appsFlyerUID: String
    private let version: String
    private let buildVersion: Int
    
    private let jsonEncoder = JSONEncoder()
    
    private var cancellations = Set<AnyCancellable>()
    
    private let prefTokenName = ":uinstall:shared:token"
    private let prefLastSuccessToken = ":uinstall:last:success:token"
    
    private var currentToken: String? = nil
    
    private let isDebug: Bool
    
    private let debugPrefix = "UinstallTracker: "

    public init(_ applicationToken: String, _ appPrefix: String, _ appsFlyerUID: String, _ amplitudeUserId: String, _ isDebug: Bool) {
        self.applicationToken = applicationToken
        self.amplitudeUserId = amplitudeUserId
        self.appPrefix = appPrefix
        self.appsFlyerUID = appsFlyerUID
        
        self.version = Bundle.main.appBuild
        self.buildVersion = Int(Bundle.main.appVersionLong) ?? 1
        
        self.isDebug = isDebug
        
        if let hasToken = UserDefaults.standard.value(forKey: prefTokenName) as? String {
            trySendNewToken(newToken: hasToken)
        }
    }
    
    func updateUninstallToken(token: String) {
        if let successToken = UserDefaults.standard.value(forKey: prefLastSuccessToken) as? String, successToken == token {
            trySendNewToken(newToken: "Success token are the same, returning")
            return
        }
        UserDefaults.standard.setValue(token, forKey: prefTokenName)
        UserDefaults.standard.setValue(nil, forKey: prefLastSuccessToken)
        self.currentToken = token
        
        cancellations = Set<AnyCancellable>()
        retries = 0
        
        trySendNewToken(newToken: token)
    }
    
    private var retries = 0
    
    private func trySendNewToken(newToken: String) {
        guard let realURL = URL(string: "https://tdw.captain.show/users") else {
            tryDebugPrint(item: "Cannot resolve URL: https://tdw.captain.show/users")
            return
        }
        var request = URLRequest(url: realURL)
        request.method = .post
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let userDto = UserDto(uid: "\(appPrefix):\(appsFlyerUID)", appToken: applicationToken, version: version, versionCode: buildVersion, amplitudeUserId: amplitudeUserId, token: newToken)
        
        guard let httpData = try? jsonEncoder.encode(userDto) else {
            tryDebugPrint(item: "Failed to encode UserDto: \(userDto)")
            return
        }
        
        request.httpBody = httpData
        
        AF.request(request)
            .validate(statusCode: 200...300)
            .publishData()
            .sink { [weak self] completion in
                guard let `self` = self else { return }
                self.tryDebugPrint(item: "Sending UserDto to global storage was completed")
            } receiveValue: { [weak self] dataResponse in
                guard let `self` = self else { return }
                switch dataResponse.result {
                case .success(_):
                    UserDefaults.standard.setValue(nil, forKey: self.prefTokenName)
                    UserDefaults.standard.setValue(newToken, forKey: self.prefLastSuccessToken)
                    break
                case .failure(let error):
                    self.tryDebugPrint(item: "Sending was completed with error : \(error). We're cruising to retry")
                    self.retryCruise(token: newToken)
                    break
                }
            }.store(in: &cancellations)

    }
    
    private func retryCruise(token: String) {
        if retries >= 5 {
            //TOO MUCH RETRIES, MAKE A LARGE DELAY BEFORE THE NEXT ONE
            Timer.publish(every: 60 * 3, on: .main, in: .common)
                .autoconnect()
                .prefix(1)
                .sink { [weak self] _ in
                    guard let `self` = self else { return }
                    self.retries = 0
                    self.trySendNewToken(newToken: token)
                }.store(in: &cancellations)
            return
        }
        retries = retries + 1
        Timer.publish(every: 2.17 * Double(retries + 1), on: .main, in: .common)
            .autoconnect()
            .prefix(1)
            .sink { [weak self] _ in
                guard let `self` = self else { return }
                self.trySendNewToken(newToken: token)
            }.store(in: &cancellations)
    }
    
    private func tryDebugPrint(item: Any) {
        if isDebug {
            print("\(debugPrefix)\(item)")
        }
    }
}
