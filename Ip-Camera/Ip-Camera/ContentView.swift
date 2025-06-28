//
//  ContentView.swift
//  Ip-Camera
//
//  Created by 大場史温 on 2025/06/28.
//

import SwiftUI

struct ContentView: View {
    @State private var capturedImage: UIImage?
    @State private var showingCamera = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 300, height: 400)
                    .shadow(radius: 5.0)
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 280, height: 280)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                } else {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 280, height: 280)
                }
            }
            
            HStack(spacing: 20) {
                Button(action: {
                    showingCamera.toggle()
                }) {
                    Text("写真を撮影")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Capsule())
                }
                
                if capturedImage != nil {
                    Button(action: shareToInstagram) {
                        Image(systemName: "square.and.arrow.up.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .clipShape(Circle())
                    }
                }
            }
        }
        .padding()
        .fullScreenCover(isPresented: $showingCamera) {
            ImagePicker(selectedImage: $capturedImage)
        }
    }
    
    func shareToInstagram() {
        guard let image = capturedImage else { return }
        
        let appID = ""
        
        let framedImage = createFramedImage(image: image)
        
        let items: [[String: Any]] = [[
            "com.instagram.sharedSticker.stickerImage": framedImage,
            "com.instagram.sharedSticker.backgroundTopColor": "#000000",
            "com.instagram.sharedSticker.backgroundBottomColor": "#FFFFFF"
        ]]
        
        UIPasteboard.general.setItems(items, options: [:])
        
        guard let shareInstagramStoryURL = URL(string: "instagram-stories://share?source_application=\(appID)") else { return }
        UIApplication.shared.open(shareInstagramStoryURL, options: [:], completionHandler: nil)
    }
    
    func createFramedImage(image: UIImage) -> UIImage {
        let frameSize = CGSize(width: 300, height: 400)
        let imageSize = CGSize(width: 280, height: 280)
        
        UIGraphicsBeginImageContextWithOptions(frameSize, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(origin: .zero, size: frameSize))
        
        let imageRect = CGRect(
            x: (frameSize.width - imageSize.width) / 2,
            y: 20,
            width: imageSize.width,
            height: imageSize.height
        )
        
        image.draw(in: imageRect)
        
        context.setFillColor(UIColor.blue.cgColor)
        let decorationRect = CGRect(
            x: frameSize.width - 30,
            y: frameSize.height - 30,
            width: 20,
            height: 20
        )
        context.fillEllipse(in: decorationRect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result ?? image
    }
}


#Preview {
    ContentView()
}
