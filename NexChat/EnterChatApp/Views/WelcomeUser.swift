//
//  WelcomeUser.swift
//  NexChat
//
//  Created by vipin on 02/09/25.
//

import SwiftUI
import PhotosUI

struct WelcomeUser: View {
    @EnvironmentObject var auth: AuthViewModel
    
    // MARK: - State for photo picker
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Welcome! 🎉")
                .font(.title)
            
         // MARK: - Photos Picker
            PhotosPicker(
                selection: $selectedItem,
                matching: .images
            ) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 5)
                } else {
                    // Placeholder
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .foregroundColor(.gray)
                        .blur(radius: 10)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .overlay(
                            Text("Tap to select")
                                .font(.title2)
                                .foregroundColor(.black)
                        )
                        .shadow(radius: 5)
                        
                    
                   
                      
                }
                
                
            }
            .onChange(of: selectedItem) { _ , newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
            
            Text("Select your profile photo")
                .font(.title2)
            
            // MARK: - Logout button
            Button("Logout") {
                auth.logout()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            
        }
        .padding()
    }
}

#Preview {
    WelcomeUser().environmentObject(AuthViewModel())
}
