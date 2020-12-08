//
//  LoginViewController.swift
//  Sqlite App
//
//  Created by Adithya on 05/12/20.
//

import UIKit
import CryptoSwift

class LoginViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var passwordField: UITextField!
    var db: SqliteClass = SqliteClass()
    var encryptedPwd = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if let base64cipher = try? Rabbit(key: "1234567890123456"),
            let base64 = try? passwordField.text?.encryptToBase64(cipher: base64cipher) {
            print("encrypted base64: \(base64)")
            encryptedPwd = base64
        }
        db.ValidareUser(infoUserName: username.text ?? "", infoUserPassword: encryptedPwd)
        if db.statusMsg == "Login Successfull" {
            let contactView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactViewController")as! ContactViewController
            self.navigationController?.pushViewController(contactView, animated: true)
        }
        else if db.statusMsg == "Password is not correct" {
            alertAction(db.statusMsg)
        }
        else if db.statusMsg == "username is not valid" {
            alertAction(db.statusMsg)
        }
    }
    
    @IBAction func signupAction(_ sender: Any) {
        let signUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")as! ViewController
        self.navigationController?.pushViewController(signUpView, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
