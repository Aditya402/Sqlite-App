//
//  Validations.swift
//  Sqlite App
//
//  Created by Adithya on 05/12/20.
//

import Foundation
class Validations: NSObject {
    func validpassword(mypassword : String) -> Bool {
        let passwordreg =  ("(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[@#$%^&*]).{8,}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return passwordtesting.evaluate(with: mypassword)
    }
}
