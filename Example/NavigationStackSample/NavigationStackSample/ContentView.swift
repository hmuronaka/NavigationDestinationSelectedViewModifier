//
//  ContentView.swift
//  NavigationStackSample
//
//  Created by MuronakaHiroaki on 2022/09/09.
//

import SwiftUI
    public enum ListType: Hashable {
        case simpleInt, dataLoad, multiSections, fileList
    }
 
struct ContentView: View {
    @State private var path: NavigationPath = .init()
    
    let types: [ListType] = [.simpleInt, .dataLoad, .multiSections, .fileList]
   
    var body: some View {
        // NOTE: path isn't updated 
        NavigationStack(path: $path) {
            List {
                ForEach(types.indices, id: \.self) { idx in
                    let type = types[idx]
                    NavigationLink(String(describing: type), value: type)
                }
            }
            .navigationDestination(for: ListType.self, destination: { listType in
                switch listType {
                    case .simpleInt:
                        SimpleIntList()
                    case .dataLoad:
                        DataConvertList()
                    case .multiSections:
                        MultiSectionList()
                    case .fileList:
                        PlainFileList(currentDirectory: Bundle.main.bundleURL) { url in
                            Text(url.absoluteString)
                        }
                    }
                })
            }
        .onChange(of: path) { newValue in
            NSLog("newPath: \(newValue)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
