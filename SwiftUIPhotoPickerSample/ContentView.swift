//
//  ContentView.swift
//  SwiftUIPhotoPickerSample
//
//  Created by hiraoka on 2021/12/31.
//

import SwiftUI
import PhotosUI

struct ContentView: View {

    private var symbols = ["keyboard", "hifispeaker.fill", "printer.fill", "tv.fill", "desktopcomputer", "headphones", "tv.music.note", "mic", "plus.bubble", "video"]

    private var colors: [Color] = [.yellow, .purple, .green]

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]

    private let photoPickerConfiguration: PHPickerConfiguration = {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 0
        return config
    }()

    @State var photoPickerIsPresented = false
    @State var images: [UIImage] = []

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .aspectRatio(contentMode: .fit)

                    }
                    ForEach((0...99), id: \.self) {
                        Image(systemName: symbols[$0 % symbols.count])
                            .font(.system(size: 30))
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .background(colors[$0 % colors.count])
                    }
                }
                .navigationBarTitle("イベント名")
                .toolbar {
                    ToolbarItem {
                        Button("add", action: {photoPickerIsPresented.toggle()})
                    }
                }
                .sheet(isPresented: $photoPickerIsPresented, onDismiss: nil) {
                    PhotoPicker(configuration: photoPickerConfiguration, pickedPhotos: $images, isPresented: $photoPickerIsPresented)
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

