//
//  ContentView.swift
//  practice
//
//  Created by 陳其宏 on 2021/5/13.
//

import SwiftUI
import Firebase
import FirebaseAuth

/* 最初的登入測試
let loginac = "123"
let loginpw = "456"
var SignedIn:Bool = false
*/


class AppviewModel: ObservableObject{
    
    let auth = Auth.auth()
    @Published var signedIn = false
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
    func signIn(email: String,pw: String) {
        auth.signIn(withEmail: email, password: pw){
            [weak self]result, error in guard result != nil, error == nil else{
                return
                }
        DispatchQueue.main.async {
            self?.signedIn = true
        }
        }
    }
    func signOut() {
        try? auth.signOut()
        self.signedIn = false
    }
}

struct ContentView: View {
    @EnvironmentObject var viewModel: AppviewModel
    var body: some View {
        NavigationView{
            if viewModel.signedIn{
                ListMedView()
            }else{
                SignInView()
            }
        }.onAppear{viewModel.signedIn = viewModel.isSignedIn}.preferredColorScheme(.dark)
    }
    
}

struct SignInView: View {
    @State public var email:String = ""
    @State public var pw:String = ""
    @State var AuthenticationFAIL:Bool = false
    @State var AuthenticationSuccess:Bool = false
    
    @EnvironmentObject var viewModel: AppviewModel
    
        var body: some View {
            ZStack{
            VStack{
                Spacer()
                WelcomeText()
                UserImage()
                UserTextFieldContent(email: $email)
                UserSecureFieldContent(pw: $pw)
                if AuthenticationFAIL{
                    Text("Something was wrong.Please try again.").offset(y:-10).foregroundColor(.red)
                }
                Button(action: {
                    guard !email.isEmpty, !pw.isEmpty else {return}
                    viewModel.signIn(email: email, pw: pw)
                }) {
                    ButtonContent()
                }.buttonStyle(GradientBackGroundStyle()).padding()
                Spacer()
                
            }.padding()
            if AuthenticationSuccess{
                Text("Login Successed!").font(.headline).frame(width: 250, height: 80).background(Color.green).cornerRadius(20.0).foregroundColor(.white).animation(Animation.default)
            }
            }
        }
}

struct ListMedView: View {
    @State var message = ""
    @ObservedObject var listModel = ListViewModel()
    @EnvironmentObject var viewModel : AppviewModel
    @State var docId = ""
    @State var updateMsg = false

    var body: some View{
        ZStack{
        VStack{
            List{
                ForEach(self.listModel.messages){message in
                    Text(message.msg).onTapGesture{
                        self.docId = message.id!
                        withAnimation {
                            self.updateMsg.toggle()
                        }
                    }
                }.onDelete(perform: { (indexSet) in
                    for index in indexSet{
                        self.listModel.deleteMessage(docId: index)
                    }
                })
            }
            HStack(spacing: 15){
                TextField("Message", text: self.$message).textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    
                    let message = Message(msg: self.message,date: .init(date: Date()))
                    
                    
                    self.listModel.addMessage(message: message){(status) in
                        
                    }
                    self.message = ""
            }){
                    Text("Add").fontWeight(.bold)
            }
            }.padding()
        }
            if self.updateMsg{
                UpdateView(listmodel: self.listModel, dismiss: self.$updateMsg, docId: self.$docId)
            }
        }.navigationBarTitle("Home")
        //之後製作刪除按鈕
            .navigationBarItems(leading:
                                 EditButton() ,trailing: Button(action: {viewModel.signOut()}){ Text("Logout")})
        .onAppear{
            self.listModel.getAllMessages()
        }
        }
}

struct UpdateView : View {
    @ObservedObject var listmodel = ListViewModel()
    @Binding var dismiss : Bool
    @Binding var docId : String
    @State var message = ""
    
    var body: some View{
        VStack(alignment: .leading, spacing: 25){
            Text("Message").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            TextField("Message", text: self.$message).textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack(spacing: 15){
                Button(action: {
                    self.listmodel.updateMessage(message: self.message, docId: self.docId){(status) in
                        
                    }
                    self.dismiss.toggle()
                }){
                    Text("Update").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                Button(action: {
                    withAnimation{
                        self.dismiss.toggle()
                    }
                }){
                    Text("Cancel").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(.red)
                }
            }
        }.padding().background(Color.black).cornerRadius(15).padding(.horizontal,25).background(Color.white.opacity(0.1).edgesIgnoringSafeArea(.all).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
    }
}

struct GradientBackGroundStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,  maxWidth: .infinity).padding().foregroundColor(.white).background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing)).cornerRadius(40).padding(.horizontal,20).scaleEffect(configuration.isPressed ? 0.9:1.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

struct WelcomeText: View {
    var body: some View{
        return Text("Welcome!").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
}

struct UserImage: View {
    var body: some View{
        return Image("medical").resizable().scaledToFit().frame(width: 150, height: 150).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
    }
    
}

struct ButtonContent: View {
    var body: some View{
        return HStack{
            Text("LOGIN").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        }
    }
}
struct UserTextFieldContent: View {
    @Binding var email : String
    var body: some View{
        return TextField("Email", text: $email).padding().textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.emailAddress).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
    }
}

struct UserSecureFieldContent: View {
    @Binding var pw : String
    var body: some View{
        return SecureField("password", text: $pw).padding().textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.default).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
    }
}

//圖片顯示
//@State var AuthenticationFAIL:Bool = false
//@State var AuthenticationSuccess:Bool = false
//
//if AuthenticationSuccess{
//    Text("Login Successed!").font(.headline).frame(width: 250, height: 80).background(Color.green).cornerRadius(20.0).foregroundColor(.white).animation(Animation.default)
//}
//if AuthenticationFAIL{
//    Text("Something was wrong.Please try again.").offset(y:-10).foregroundColor(.red)
////}
//func signIn(email: String,pw: String) {
//    auth.signIn(withEmail: email, password: pw){
//        (result, error) in if error != nil{
//            print(error?.localizedDescription ?? "")
//            self.AuthenticationFAIL = true
//        }else{
//            print("success")
//            self.AuthenticationSuccess = true
//            self.AuthenticationFAIL = false
//        }
//    }
//}
