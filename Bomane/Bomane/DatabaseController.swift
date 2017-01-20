//
//  DatabaseController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-01-20.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import Foundation

class DatabaseController {
    static let shared = DatabaseController()
    
    //MARK: NSCODING - save user to disk
    
    func saveUser(user: User) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(user, toFile: User.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save User...")
        } else {
            print("Successfully persisted User to disk! Yes. Win. Bigly")
        }
    }
    
    func saveUser(user: User, completion: (Bool) -> Void) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(user, toFile: User.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save User...")
            completion(false)
        } else {
            print("Successfully persisted User to disk! Yes. Win. Bigly")
            completion(true)
        }
    }
    
    func loadUser() -> User? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User
    }
    
    func logoutUser() {
        deleteUserFile()
    }
    
    func deleteUserFile() {
        let logout = FileManager.default.fileExists(atPath: User.ArchiveURL.path)
        if logout {
            do {
                try FileManager.default.removeItem(atPath: User.ArchiveURL.path)
            } catch {
                print("Error deleting object from database")
            }
        }
    }
    


}
