//
//  PlainFileList.swift
//  NavigationStackSample
//
//  Created by MuronakaHiroaki on 2022/09/22.
//

import SwiftUI

fileprivate extension FileManager {
    func isDirectory(url: URL) -> Bool {
        var isDir:ObjCBool = false
        let result = self.fileExists(atPath: url.path, isDirectory: &isDir)
        return result && isDir.boolValue
    }
}

@MainActor
class PlainFileListModel: ObservableObject {
    @Published var currentDirectory: URL?
    @Published var paths: [URL] = []
    
    func setup(currentDirectory: URL) throws {
        self.currentDirectory = currentDirectory
        self.paths = try FileManager.default.contentsOfDirectory(at: currentDirectory, includingPropertiesForKeys: [.parentDirectoryURLKey, .creationDateKey, .fileSizeKey], options: [])
    }
}

struct PlainFileList<Destination: View>: View {
    
    let currentDirectory: URL
    @ViewBuilder let destination: (URL) -> Destination
    
    @StateObject private var model: PlainFileListModel = .init()
    @State private var selection: URL?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(model.paths, id: \.self) { url in
                NavigationLink(value: url) {
                    let systemImage = FileManager.default.isDirectory(url: url) ?
                        "folder" : "doc.text"
                    Label(url.lastPathComponent, systemImage: systemImage)
                }
            }
        }
        .onAppear() {
            try! self.model.setup(currentDirectory: self.currentDirectory)
        }
        .navigationDestination(selected: $selection) { url in
            if FileManager.default.isDirectory(url: url) {
                PlainFileList(currentDirectory: url, destination: destination)
            } else {
                self.destination(url)
            }
        }
        .navigationTitle(currentDirectory.lastPathComponent)
    }
}

struct PlainFileList2<Destination: View>: View {
    
    let current: URL
    let paths: [URL]
    @ViewBuilder let destination: (URL) -> Destination
    @State private var selection: URL?
    @State private var childPaths: [URL]?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(paths, id: \.self) { url in
                if FileManager.default.isDirectory(url: url) {
                    NavigationLink(value: url) {
                        Label(url.lastPathComponent, systemImage: "folder")
                    }
                } else {
                    self.destination(url)
                }
                
            }
        }
        .navigationDestination(selection: $selection, item: $childPaths ) { childPaths in
            if let selection {
                PlainFileList2(current: selection, paths: childPaths, destination: self.destination)
            }
        }
        .onChange(of: selection, perform: { newValue in
            if let newValue, FileManager.default.isDirectory(url: newValue) {
                self.childPaths = try! FileManager.default.contentsOfDirectory(at: newValue, includingPropertiesForKeys: [.parentDirectoryURLKey, .creationDateKey, .fileSizeKey], options: [])
            } else {
                self.childPaths = nil
            }
        })
        .navigationTitle(current.lastPathComponent)
    }
}
