//
//  UserDto.swift
//  uinstall-remove
//
//  Created by Radzivon Bartoshyk on 29.09.21.
//

import Foundation

class UserDto: Codable {
     init(uid: String, appToken: String, version: String, versionCode: Int, amplitudeUserId: String, token: String) {
        self.uid = uid
        self.appToken = appToken
        self.version = version
        self.versionCode = versionCode
        self.amplitudeUserId = amplitudeUserId
        self.token = token
    }
    
    let uid: String
    let appToken: String
    let version: String
    let versionCode: Int
    let amplitudeUserId: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case uid = "uid"
        case appToken = "app_token"
        case version = "version"
        case versionCode = "version_code"
        case amplitudeUserId = "amplitude_user_id"
        case token = "token"
    }
}
