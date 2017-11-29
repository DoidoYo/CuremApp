//
//  FirebaseModel.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/28/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class FirebaseHelper: NSObject {
    
    static var user: User!
    static var pendingPatient: PendingUserModel? = nil
    static var pendingID:String?
    static var userInfo: UserModel?
    static var doctorInfo:UserModel?
    static var savedUser:SavedUser?
    
    static let dbRef = Database.database().reference()
    
    static func login(_ model: LoginModel, completion: @escaping (_ err: Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: model.email, password: model.password, completion: {
            (user, error) in
            
            if let error = error {
                print("ERROR: \(error)")
            } else {
                self.user = user
                self.createSavedUser()
            }
            completion(error)
        })
    }
    
    private static func createSavedUser() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetchRequest:NSFetchRequest<SavedUser> = SavedUser.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", self.user.uid)
            let savedUser = try context.fetch(fetchRequest)
            
//            debug stuff
//            let us = try! context.fetch(SavedUser.fetchRequest())
//            for u in us {
//                let u = u as! SavedUser
//                print(u.id)
//            }
            
            if savedUser.count == 1 {
                self.savedUser = savedUser[0]
                print("USER FOUND")
            } else if savedUser.count > 1 {
                print("ERROR: more than 1 user found")
            } else if savedUser.count == 0  {
                let newSavedUser = SavedUser(context: context)
                newSavedUser.id = self.user.uid
                self.savedUser = newSavedUser
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                print("CREATING USER")
            }
            
        } catch {
            print("Fetching Failed")
        }
    }
    
    static func logout() {
        try! Auth.auth().signOut()
    }
    
    static func getPatientFrom(code: String, completion: @escaping (_ err: Error?) -> Void) {
        dbRef.child("PendingPatients").queryOrdered(byChild: "code").queryEqual(toValue: code.lowercased()).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let snap = snapshot.value as? NSDictionary {
                pendingID = snap.allKeys[0] as! String
                if let patDic = snap.allValues[0] as? NSDictionary {
                    pendingPatient = try? PendingUserModel.decode(patDic)
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
    
    //deleted saved message data
    private static func deleteData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var savedMessages: [SavedMessage]!
        do {
            let fetchRequest:NSFetchRequest<SavedMessage> = SavedMessage.fetchRequest()
            let sort = NSSortDescriptor(key: "time", ascending: false)
            fetchRequest.sortDescriptors = [sort]
            savedMessages = try context.fetch(fetchRequest)
            
            for i in savedMessages {
                context.delete(i)
            }
            
        } catch {
            print("Fetching Failed")
        }
    }
    
    static func create(user: CreateUserModel, completion: @escaping (_ err: Error?) -> Void) {
        Auth.auth().createUser(withEmail: user.email, password: user.password, completion: {
            (user, error) in
            
            if let error = error {
                completion(error)
            } else {
                self.user = user
                
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
                
                self.createSavedUser()
                
                completion(nil)
            }
            
        })
    }
    
    static func getLatestMeasurements(completion: @escaping (_ measurements : [MeasurementModel]) -> Void) {
        
        dbRef.child("Patients").child(user.uid).queryLimited(toFirst: 14).observeSingleEvent(of: .value, with: {
            (snapshot) in
            var measurements: [MeasurementModel] = []
            
            if let snap = snapshot.value as? NSDictionary {
                for item in snap.allValues {
                    let item = item as! NSDictionary
                    
                    measurements.append(try! MeasurementModel.decode(item))
                    
                }
            }
            
            completion(measurements)
            
        })
        
    }
    
    static func getUser(completion: @escaping (_ error: Error?) -> Void) {
        dbRef.child("Users").child(user.uid).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snap = snapshot.value as? NSDictionary {
                let userModel = try! UserModel.decode(snap)
                userInfo = userModel
                completion(nil)
            }
        })
    }
    
    static func setMeasurement(_ mea:MeasurementModel) {
        dbRef.child("Patients").child(user.uid).childByAutoId().setValue(try! mea.encodeToDic())
    }
    
    static func sendMsg(_ msg:MessageModel) {
        let child = dbRef.child("Chat").child(userInfo!.chat).childByAutoId()
        let msg = MessageModel(id: child.key, sender: msg.sender, text: msg.text, time: msg.time)
        
        child.setValue(try! msg.encodeToDic())
    }
    
    static func observeChat(from: Double, completion: @escaping (_ measurements : MessageModel) -> Void) {
        dbRef.child("Chat").child(userInfo!.chat).queryOrdered(byChild: "time").queryStarting(atValue: from).observe(.childAdded, with: {
            (snapshot) in
            if let snap = snapshot.value as? NSDictionary {
                completion(try! MessageModel.decode(snap))
            }
        })
    }
    
    static func getChatMsg(completion: @escaping (_ measurements : [MessageModel]) -> Void) {
        
        dbRef.child("Chat").child(userInfo!.chat).observeSingleEvent(of: .value, with: {
            (snapshot2) in
            var msgs: [MessageModel] = []
            if let snap2 = snapshot2.value as? NSDictionary {
                for item in snap2.allValues {
                    let item = item as! NSDictionary
                    msgs.append(try! MessageModel.decode(item))
                }
            }
            msgs.sort(by: {
                (first, next) in
                
                if first.time > next.time {
                    return true
                }
                return false
            })
            completion(msgs)
            
        })
    }
    
}
