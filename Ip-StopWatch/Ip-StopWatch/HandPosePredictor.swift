//
//  HandPosePredictor.swift
//  Ip-StopWatch
//
//  Created by 大場史温 on 2025/06/28.
//

import Foundation
import Vision
import CoreML
@preconcurrency import AVFoundation

@MainActor
class HandPosePredictor: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var currentHandPose: String = ""

    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    private let handPoseModel = try! StopWatchHandPoseClassifier(configuration: MLModelConfiguration())

    func setupCamera(session: AVCaptureSession) {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                    for: .video,
                                                    position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else { return }

        session.beginConfiguration()
        session.sessionPreset = .high

        if session.canAddInput(input) {
            session.addInput(input)
        }

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)
        ]
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.queue"))

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()

        DispatchQueue.global(qos: .userInitiated).async { [weak session] in
            session?.startRunning()
        }
    }

    nonisolated func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        
        Task { @MainActor in
            do {
                try handler.perform([handPoseRequest])
                
                guard let handPose = handPoseRequest.results else {
                    self.currentHandPose = ""
                    return
                }

                guard let firstHand = handPose.first else {
                    self.currentHandPose = ""
                    return
                }

                guard let keypointsMultiArray = try? firstHand.keypointsMultiArray() else {
                    self.currentHandPose = ""
                    return
                }

                await self.predictPose(array: keypointsMultiArray)

            } catch {
                self.currentHandPose = ""
            }
        }
    }

    private func predictPose(array: MLMultiArray) async {
        do {
            let prediction = try handPoseModel.prediction(poses: array)
            self.currentHandPose = prediction.label
        } catch {
            self.currentHandPose = ""
        }
    }
}
