//
//  SqliteClass.swift
//  Sqlite App
//
//  Created by Adithya on 04/12/20.
//

import UIKit
import SQLite3


class SqliteClass {
    
    let dbpath: String = "chat.sqlite"
    var db: OpaquePointer?
    var statusMsg: String? = ""
    
    init() {
        db = openDatabase()
        createTable()
    }
    
    func openDatabase() -> OpaquePointer? {
        let fileurl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbpath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileurl.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        }
        else {
            print("Successfully opened Connection to database at \(dbpath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS users(Id INTEGER PRIMARY KEY,name TEXT,password TEXT, image TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("users table createdd")
            }
            else {
                print("users table not created")
            }
        }
        else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(id:Int, name: String, password: String, image: String) {
        let users = read()
        for user in users {
            if  user.id == id {
                return
            }
            else if user.name == name {
                statusMsg = "username already created"
                return
            }
        }
        let insertStatemntString = "INSERT INTO users (Id, name, password, image) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatemntString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(Int64(id)))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (image as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row")
                statusMsg = "Account is created Successfully"
            }
            else {
                print("could not insert row")
                statusMsg = "Account is not created"
            }
        }
        else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Users] {
        let queryStatementString = "SELECT * FROM users;"
        var queryStatement: OpaquePointer? = nil
        var userlist : [Users] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let image = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                
                userlist.append(Users(id: Int(id), name: name, password: password, image: image))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return userlist
    }
    
    func deleteByName(name:String) {
        let deleteStatementStirng = "DELETE FROM users WHERE name = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 2, (name as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func update(name: String, Id : Int) {
        let updateStatementString = "UPDATE users SET name = '\(name)' WHERE Id = '\(Id)';"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
            } else {
                print("\nCould not update row.")
            }
        } else {
            print("\nUPDATE statement is not prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func ValidareUser(infoUserName: String, infoUserPassword: String) {
        if sqlite3_open(getDBPath(), &db) == SQLITE_OK {
            let querySQL = "SELECT name, password FROM users Where name = \"\(infoUserName)\""
            print("\(querySQL)")
            var searchStatement: OpaquePointer?
            if sqlite3_prepare_v2(db, querySQL, -1, &searchStatement, nil) == SQLITE_OK {
                if sqlite3_step(searchStatement) == SQLITE_ROW {
                    let username = String(describing: String(cString: sqlite3_column_text(searchStatement, 0)))
                    let password = String(describing: String(cString: sqlite3_column_text(searchStatement, 1)))
                    if username == infoUserName {
                        if password == infoUserPassword {
                            statusMsg = "Login Successfull"
                        }
                        else {
                            statusMsg = "Password is not correct"
                        }
                    }
                    else {
                        statusMsg = "username is not valid"
                    }
                }
                else {
                    statusMsg = "username is not valid"
                }
            }

            sqlite3_finalize(searchStatement)
        }
    }
    
    func getDBPath() -> String? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)
        let documentsDir = paths[0]

        return URL(fileURLWithPath: documentsDir).appendingPathComponent("chat.sqlite").path
    }
    
}
