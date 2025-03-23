//
//  ContentView.swift
//  ObjectDetection
//
//  Created by Weerawut Chaiyasomboon on 23/03/2568.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var vm = ContentViewModel()
    
    var body: some View {
        VStack {
            Text("Object Detection: RESNET50")
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                
                if let image = selectedImage {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                }
            }
            
            Text(vm.detection)
                .font(.title2)
                .padding()
            
            PhotosPicker(selection: $photoPickerItem) {
                Text("Find Image")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 8))
                    .padding(.horizontal,8)
            }
            
            Spacer()
        }
        .onChange(of: photoPickerItem) {
            Task {
                guard let photoData = try? await photoPickerItem?.loadTransferable(type: Data.self), let uiImage = UIImage(data: photoData) else {
                    return
                }
                
                self.selectedImage = Image(uiImage: uiImage)
                vm.detectObject(uiImage: uiImage)
            }
        }
    }
}

#Preview {
    ContentView()
}
