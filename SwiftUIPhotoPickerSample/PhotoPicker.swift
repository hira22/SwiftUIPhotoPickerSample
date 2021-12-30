//
//  PhotoPicker.swift
//  SwiftUIPhotoPickerSample
//
//  Created by hiraoka on 2021/12/31.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {

    let configuration: PHPickerConfiguration
    @Binding var pickedPhotos: [UIImage]
    @Binding var isPresented: Bool

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        print(#function)
        let viewController = PHPickerViewController(configuration: configuration)
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        print(#function)
    }

    class Coordinator: PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print(#function)
            for result in results {
                if !result.itemProvider.canLoadObject(ofClass: UIImage.self) { return }
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let error = error {
                        print("❗️\(error.localizedDescription)")
                        return
                    }
                    guard let image = image as? UIImage else {
                        print("no image")
                        return
                    }

                    self.parent.pickedPhotos.append(image)
                }
            }

            //            parent.isPresented = false
            picker.dismiss(animated: true)
        }
    }
}

struct PhotoPicker_Previews: PreviewProvider {

    static let configuration: PHPickerConfiguration = {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 3
        return config
    }()

    static var previews: some View {
        PhotoPicker(configuration: configuration, pickedPhotos: .constant([]), isPresented: .constant(true))
            .preferredColorScheme(.dark)
    }
}
