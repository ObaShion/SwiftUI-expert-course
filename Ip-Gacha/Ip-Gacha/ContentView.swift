//
//  ContentView.swift
//  Ip-Gacha
//
//  Created by 大場史温 on 2025/06/28.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
    
    @State private var isShowResult: Bool = false
    
    @State private var characterImageName: String = ""
    
    var body: some View {
        VStack {
            Button {
                let number = Int.random(in: 0..<9)
                switch number {
                 case 9:
                     characterImageName = "IoTMesh"
                 case 8:
                     characterImageName = "camera"
                 case 0..<7:
                     characterImageName = "iphone"
                 default:
                     characterImageName = ""
                 }
                print(characterImageName)
                isShowResult.toggle()
            } label: {
                Text("ガチャを引く")
            }
        }
        .fullScreenCover(isPresented: $isShowResult, content: {
            ZStack (alignment: .topTrailing) {
                ARViewContainer(characterImageName: self.$characterImageName)
                    .ignoresSafeArea()
                Button {
                    isShowResult.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .padding()

            }
        })
        .padding()
    }
}

#Preview {
    ContentView()
}


struct ARViewContainer: UIViewRepresentable {
    @Binding var characterImageName: String

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        arView.session.run(config)

        guard let uiImage = UIImage(named: characterImageName),
              let cgImage = uiImage.cgImage else {
            print("画像の読み込み失敗")
            return arView
        }

        guard let texture = try? TextureResource(image: cgImage, options: .init(semantic: .color)) else {
            return arView
        }

        let textureParameter = MaterialParameters.Texture(texture)

        var material = UnlitMaterial()
        material.color = .init(texture: textureParameter)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: 1.0))
        
        let mesh = MeshResource.generatePlane(width: 0.3, height: 0.3)
        let entity = ModelEntity(mesh: mesh, materials: [material])

        let anchor = AnchorEntity(world: SIMD3<Float>(0, 0, -0.5))
        anchor.addChild(entity)
        arView.scene.anchors.append(anchor)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}
