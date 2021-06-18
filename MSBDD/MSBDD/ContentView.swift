//
//  ContentView.swift
//  MSBDD
//
//  Created by 陳其宏 on 2021/4/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var taskName: String = ""
    @State private var tasks = [String]()
    
    var body: some View {
        VStack{
            TextField("Enter task", text: $taskName)
                .accessibility(identifier: "taskNameTextField")
            
            Button("Add"){
                self.tasks.append(self.taskName)
            }.accessibility(identifier: "addTaskButton")
            
            List(self.tasks, id: \.self){task in
                
                Text(task)
            }
Spacer()
            
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
