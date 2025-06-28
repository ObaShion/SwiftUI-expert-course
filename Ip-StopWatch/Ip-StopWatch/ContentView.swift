//
//  ContentView.swift
//  Ip-StopWatch
//
//  Created by 大場史温 on 2025/06/28.
//

import SwiftUI
import AVFoundation

@MainActor
struct ContentView: View {
    @StateObject var predictor = HandPosePredictor()
    @State private var time: Float = 0.0
    @State private var isRunning = false
    
    let captureSession = AVCaptureSession()
    
    @State private var timer: Timer?
    
    
    var body: some View {
        VStack {
            Text(String(format: "%.1f", time))
                .font(.largeTitle)
                .padding()
            
            Text("今の手のポーズ \(predictor.currentHandPose)")
                .padding()

            CameraPreview(session: captureSession)
                .onAppear {
                    predictor.setupCamera(session: captureSession)
                }
        }
        .onChange(of: predictor.currentHandPose) { oldValue, newValue in
            if oldValue != newValue {
                handlePose(pose: newValue)
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
        .padding()
    }
    
    private func handlePose(pose: String) {
        switch pose {
        case "rock":
            pauseTimer()
        case "paper":
            startTimer()
        case "scissors":
            resetTimer()
        default:
            break
        }
    }

    private func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            Task { @MainActor in
                time += 0.1
            }
        }
    }

    private func pauseTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    private func resetTimer() {
        pauseTimer()
        time = 0
    }
}

#Preview {
    ContentView()
}
