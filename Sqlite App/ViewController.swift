//
//  ViewController.swift
//  Sqlite App
//
//  Created by Adithya on 04/12/20.
//

import UIKit
import CryptoSwift

class ViewController: BaseViewController {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var userView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var confirmPasswordView: UIView!
    @IBOutlet var mobileNUmberField: UITextField!
    
    @IBOutlet var signUpBtn: UIButton!
    
    var db: SqliteClass = SqliteClass()
    var users:[Users] = []
    var idStr = String()
    var imageData = Data()
    var imageStr = String()
    var encryptedPwd = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavigationtitle()
        self.navigationTitle = "Registration"
        self.titleLabel.sizeToFit()
        showBackButton()
        idStr = randomString(length: 6)
    }
    
    func randomString(length: Int) -> String {
        let letters = "1234567890"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func signupAction(_ sender: Any) {
        if let base64cipher = try? Rabbit(key: "1234567890123456"),
            let base64 = try? passwordField.text?.encryptToBase64(cipher: base64cipher) {
            print("encrypted base64: \(base64)")
            encryptedPwd = base64
        }
        let password = Validations().validpassword(mypassword: passwordField.text ?? "")
        if password == false {
            alertAction("Invalid Password chosen. Password must contain at least 1 special character 1 lower case character, 1 UPPER case character and a number. Passwords need to be at least 8 characters in length. Please choose another and try again.")
        }
        else {
            let idNum = Int(idStr) ?? 0
            db.insert(id: idNum, name: userNameField.text ?? "", password: encryptedPwd, image: imageStr)
            if db.statusMsg == "Account is created Successfully" {
                let alert = UIAlertController(title: nil, message: "Account is created Successfully", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                    let contactView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactViewController")as! ContactViewController
                    self.navigationController?.pushViewController(contactView, animated: true)
                })
                alert.addAction(okButton)
                present(alert, animated: true)
            }
            else if db.statusMsg == "username already created" {
                alertAction("Username already created")
            }
         }
        
    }
    @IBAction func signinAction(_ sender: Any) {
        let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")as! LoginViewController
        self.navigationController?.pushViewController(loginView, animated: true)
    }
    @IBAction func cameraAction(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.getImage(fromSourceType: .camera)
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.getImage(fromSourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: {
        })
    }
    
}

extension UIViewController {
    func alertAction(_ msgStr: String?) {
        let alert = UIAlertController(title: nil, message: msgStr, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            UINavigationBar.appearance().tintColor = .white
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imageData = Data()
        imageData = (info[.originalImage] as? UIImage)!.jpegData(compressionQuality: 1)!
        let image : UIImage = UIImage(data: imageData)!
        let selectImage = resizeImage(image: image, targetHeight: 100.0)
        profileImage.image = selectImage
        imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
        dismiss(animated:true, completion: nil)
    }
}

extension UIImage {
    func getFileSizeInfo(allowedUnits: ByteCountFormatter.Units = .useMB,
                         countStyle: ByteCountFormatter.CountStyle = .file) -> String? {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.countStyle = countStyle
        return getSizeInfo(formatter: formatter)
    }
    func getFileSize(allowedUnits: ByteCountFormatter.Units = .useMB,
                     countStyle: ByteCountFormatter.CountStyle = .memory) -> Double? {
        guard let num = getFileSizeInfo(allowedUnits: allowedUnits, countStyle: countStyle)?.getNumbers().first else { return nil }
        return Double(truncating: num)
    }
    
    func getSizeInfo(formatter: ByteCountFormatter, compressionQuality: CGFloat = 1.0) -> String? {
        guard let imageData = jpegData(compressionQuality: compressionQuality) else { return nil }
        return formatter.string(fromByteCount: Int64(imageData.count))
    }
}

extension String {
    func getNumbers() -> [NSNumber] {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let charset = CharacterSet.init(charactersIn: " ,.")
        return matches(for: "[+-]?([0-9]+([., ][0-9]*)*|[.][0-9]+)").compactMap { string in
            return formatter.number(from: string.trimmingCharacters(in: charset))
        }
    }
    
    func matches(for regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: [.caseInsensitive]) else { return [] }
        let matches  = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        return matches.compactMap { match in
            guard let range = Range(match.range, in: self) else { return nil }
            return String(self[range])
        }
    }
}

