//
//  FirebaseModel.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/28/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import Firebase

class FirebaseHelper: NSObject {
    
    static var user: User!
    static var pendingPatient: PendingPatientModel? = nil
    static var pendingID:String?
    
    static let dbRef = Database.database().reference()
    
    static func login(_ model: LoginModel, completion: @escaping (_ err: Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: model.email, password: model.password, completion: {
            (user, error) in
            
            if let error = error {
                print("ERROR: \(error)")
            } else {
                self.user = user
            }
            completion(error)
        })
    }
    
    static func getPatientFrom(code: String, completion: @escaping (_ err: Error?) -> Void) {
        dbRef.child("PendingPatients").queryOrdered(byChild: "code").queryEqual(toValue: code.lowercased()).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let snap = snapshot.value as? NSDictionary {
                pendingID = snap.allKeys[0] as! String
                if let patDic = snap.allValues[0] as? NSDictionary {
                    pendingPatient = try? PendingPatientModel.decode(patDic)
                }
            }
            
            if pendingPatient == nil {
                completion(NSError(domain: "Code not found!", code: -1, userInfo: nil))
            } else {
                completion(nil)
            }
            
        }, withCancel: {
            (error) in
            print("ERROR: \(error)")
            completion(error)
        })
        
    }
    
    static func create(user: CreateUserModel, completion: @escaping (_ err: Error?) -> Void) {
        Auth.auth().createUser(withEmail: user.email, password: user.password, completion: {
            (user, error) in
            
            if let error = error {
                completion(error)
            } else {
                self.user = user
                
                print("YEEEEE")
                
                var values = try! pendingPatient!.encodeToDic()
                values.removeValue(forKey: "code")
                
                let chatRef = dbRef.child("Chat").childByAutoId()
                values["chat"] = chatRef.key
                
                //remove from pendingpatients
                dbRef.child("PendingPatients").child(pendingID!).removeValue()
                //add to physician
                dbRef.child("Users").child(user!.uid).setValue(values)
               //add to users
                dbRef.child("Physicians").child(pendingPatient!.doc).child(user!.uid).setValue(["chat":chatRef.key, "id":user!.uid])
                
                
                completion(nil)
            }
            
        })
    }
    
    static func getChatMsg(amount: Int) {
        
        
        
    }
    
}
