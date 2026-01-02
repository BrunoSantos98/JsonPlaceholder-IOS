//
//  UserModel.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import Foundation

struct UserModel: Identifiable, Codable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
    var phone: String
    var website: String
    var company: Company
}

struct Address: Codable {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: Geo
}

struct Geo: Codable {
    var lat: String
    var lng: String
}

struct Company: Codable {
    var name: String
    var catchPhrase: String
    var bs: String
}

struct TodoTasks: Codable, Identifiable, Hashable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}



extension UserModel {
    init() {
        self.id = 0
        self.name = ""
        self.username = ""
        self.email = ""
        self.phone = ""
        self.website = ""
        self.address = Address()
        self.company = Company()
    }
}

extension Address {
    init() {
        self.street = ""
        self.suite = ""
        self.city = ""
        self.zipcode = ""
        self.geo = Geo()
    }
}

extension Geo {
    init() {
        self.lat = ""
        self.lng = ""
    }
}

extension Company {
    init() {
        self.name = ""
        self.catchPhrase = ""
        self.bs = ""
    }
}
