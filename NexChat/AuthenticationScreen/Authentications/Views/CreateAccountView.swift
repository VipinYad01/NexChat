//
//  CreateAccountView.swift
//  Firebase Authentication
//
//  Created by vipin on 13/07/25.
//

import SwiftUI
import FirebaseAuth

struct CreateAccountView: View {
    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert : Bool = false
    @State private var alertMessage = ""
    @State var isLoading = false
    var body: some View {
            VStack{
                
                Text("Please complete all information to create an account.")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                InputView(
                    placeholder: "Email or Phone number",
                    text: $email
                )
                InputView(
                    placeholder: "Full name",
                    text: $fullName
                )
                PasswordInputView(
                    placeholder: "Password",
                    isSecureField: true,
                    text: $password
                )
                PasswordInputView(
                    placeholder: "Confirm password",
                    isSecureField: true,
                    text: $confirmPassword
                )
                HStack{
                    Spacer()
                    Text("min 8 characters")
                        .font(.footnote)
                        .padding(.top,5)
                }
                
                
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .padding()
                }
                else {
                    Button {
                        signup()
                    }
                    label: {
                        Text ("Create Account")
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Capsule().fill(Color.teal))
                    }
                }
               
                
              
            }
            .alert(isPresented: $showAlert) {
                      Alert(
                          title: Text("Error"),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK"))
                      )
                  }
            .navigationTitle("Set up your account")
            .ignoresSafeArea()
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom,16)
    }
    
    func signup() {
        
        guard !email.isEmpty else {
            alertMessage = "Please enter your email"
            showAlert = true
            return
        }
        guard !fullName.isEmpty else {
            alertMessage = "Please enter your name"
            showAlert = true
            return
        }
        guard !password.isEmpty else {
            alertMessage = "Please enter your password"
            showAlert = true
            return
        }
        guard !confirmPassword.isEmpty else {
            alertMessage = "Please confirm your password"
            showAlert = true
            return
        }
        guard confirmPassword == password else {
            alertMessage = "Confirm password does not match"
            showAlert = true
            return
        }

        // Start loader
        isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            // Switch back to main thread
            DispatchQueue.main.async {
                // Stop loader
                isLoading = false
                
                if let error = error {
                    // Show alert on error
                    alertMessage = error.localizedDescription
                    showAlert = true
                } 
            }
        }
    }


}

#Preview {
    CreateAccountView()
}


struct PasswordInputView: View {
    let placeholder: String
    @State var isSecureField: Bool = false
    @Binding var text: String
    @State var protection : Bool = false
    var body: some View {
        VStack(spacing: 12) {
            if isSecureField {
                HStack{
                    SecureField (placeholder, text: $text)
                        .textContentType(.newPassword)
                          .autocorrectionDisabled(true)
                          .textInputAutocapitalization(.never)
                    Spacer()
                    Button {
                        withAnimation {
                            protection.toggle()
                            isSecureField.toggle()
                        }
                    } label: {
                        if protection {
                            Image(systemName:"eye")
                                .frame(width: 10, height: 10)
                                .padding(.trailing, 8)
                                .foregroundColor(.gray)
                        }
                        else{
                            Image(systemName:"eye.slash")
                                .frame(width: 10, height: 10)
                                .padding(.trailing, 8)
                                .foregroundColor(.gray)
                        }
                    }

                   
                }
                
            } else {
                HStack {
                    TextField (placeholder, text: $text)
                    Spacer()
                    Button {
                        protection.toggle()
                        isSecureField.toggle()
                       
                    } label: {
                        if protection {
                            Image(systemName:"eye")
                                .frame(width: 10, height: 10)
                                .padding(.trailing, 8)
                                .foregroundColor(.gray)
                        }
                        else{
                            Image(systemName:"eye.slash")
                                .frame(width: 10, height: 10)
                                .padding(.trailing, 8)
                                .foregroundColor(.gray)
                        }
                    }
                   
                }
            }
            Divider()
        }
    }
}
