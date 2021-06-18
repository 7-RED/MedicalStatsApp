//
//  ListView.swift
//  practice
//
//  Created by 陳其宏 on 2021/6/17.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class ListViewModel: ObservableObject {
    
    @Published var messages : [Message] = []
    
    let ref = Firestore.firestore()
    
    
    func getAllMessages()  {
        //排序
        ref.collection("Messages").order(by: "date",descending:  false).addSnapshotListener{
            (snap, err) in
            guard let docs = snap else{return}
            
            docs.documentChanges.forEach{(doc)in
                let message = try! doc.document.data(as: Message.self)
                
                
                if doc.type == .added{
                    self.messages.append(message!)
                }
                
                if doc.type == .modified{
                    //修改
                    for i in 0..<self.messages.count {
                        if self.messages[i].id ==
                            message?.id!{
                            self.messages[i] = message!
                        }
                    }
                }
                
            }
        }
    }
    
    func addMessage(message: Message,completion: @escaping(Bool) -> ()) {
        do{
            let _ = try ref.collection("Messages").addDocument(from: message){(error) in
                
                if error != nil{
                    completion(false)
                    return
                }
                completion(true)
            }
        }catch{
            print(error.localizedDescription)
            completion(false)
        }
            
        
    }
    
    func deleteMessage(docId: Int) {
        ref.collection("Messages").document(messages [docId].id!).delete{
            (error) in
            if error != nil{
                return
            }
            self.messages.remove(at: docId)
        }
    }
    
    func updateMessage(message : String,docId: String,completion: @escaping (Bool)->()) {
        ref.collection("Messages").document(docId).updateData(["message":message]){(error) in
            if error != nil{
                completion(false)
                return
            }
            completion(true)
        }
    }
}
