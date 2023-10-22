//
//  CameraView.swift
//  PerfectPortion
//
//  Created by Ryan Nair on 10/21/23.
//

import SwiftUI
import AVKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?

    func makeUIViewController(context: Context) -> CameraViewController {
        let viewController = CameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let imageData = photo.fileDataRepresentation(),
               let image = UIImage(data: imageData) {
                parent.capturedImage = image
            }
        }
    }

    class CameraViewController: UIViewController {
        var delegate: Coordinator?

        private var captureSession: AVCaptureSession!
        private var cameraOutput: AVCapturePhotoOutput!

        override func viewDidLoad() {
            super.viewDidLoad()

            captureSession = AVCaptureSession()
            captureSession.sessionPreset = .photo

            guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("Unable to access the back camera!")
                return
            }

            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)

                    cameraOutput = AVCapturePhotoOutput()
                    if captureSession.canAddOutput(cameraOutput) {
                        captureSession.addOutput(cameraOutput)
                        Task.detached { [unowned self] in
                            await captureSession.startRunning()
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }

            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)

            // Add a tap gesture to capture a photo
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(capturePhoto))
            view.addGestureRecognizer(tapGesture)
        }

        @objc func capturePhoto() {
            let settings = AVCapturePhotoSettings()
            cameraOutput.capturePhoto(with: settings, delegate: delegate!)
        }
    }
}
