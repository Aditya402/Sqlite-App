//
//  UsersModel.swift
//  Sqlite App
//
//  Created by Adithya on 04/12/20.
//

import Foundation

class Users {
    var name: String = ""
    var id: Int = 0
    var password: String = ""
    var image:String = ""
    
    init(id:Int, name:String, password:String, image: String)
    {
        self.id = id
        self.name = name
        self.password = password
        self.image = image
    }
}
