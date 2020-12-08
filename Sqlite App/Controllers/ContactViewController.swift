//
//  ContactViewController.swift
//  Sqlite App
//
//  Created by Adithya on 05/12/20.
//

import UIKit
import Contacts

class ContactViewController: BaseViewController {
    
    @IBOutlet var contactTv: UITableView!
    var contacts = [CNContact]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        showNavigationtitle()
        self.navigationTitle = "Contacts"
        self.titleLabel.sizeToFit()

        let store = CNContactStore()
        let authorisation = CNContactStore.authorizationStatus(for: .contacts)
        if authorisation == .notDetermined {
            store.requestAccess(for: .contacts) { [weak self] didAuthorize,
                                                              error in
                if didAuthorize {
                    self?.retrieveContacts(from: store)
                }
            }
        } else if authorisation == .authorized {
            retrieveContacts(from: store)
        }
    }
    
    func retrieveContacts(from store: CNContactStore) {
        let containerId = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        let keystoFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                            CNContactFamilyNameKey as CNKeyDescriptor,
                            CNContactImageDataAvailableKey as CNKeyDescriptor,
                            CNContactImageDataKey as CNKeyDescriptor]
        do {
            contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keystoFetch)
            DispatchQueue.main.async { [weak self] in
              self?.contactTv.reloadData()
            }
        } catch {
            // something went wrong
            print(error) // there always is a "free" error variable inside of a catch block
        }
    }
    
    
    
    @IBAction func selfAction(_ sender: Any) {
    }
    
}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCellID", for: indexPath) as! ContactsTableViewCell
        let contact = contacts[indexPath.row]
        cell.contactLbl.text = "\(contact.givenName) \(contact.familyName)"
        return cell
    }
}
