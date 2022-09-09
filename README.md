# NavigationDestinationSelectedViewModifier

- You can detect the selected value When a user tap a navigation link in iOS 16.0.(for the purpose of converting the selected value to other data, loading data, etc.)

- You can create easily reuseable child views in NavigataionStack.

# Problem in iOS 16.0 (Xcode Version 14.0(14A309) ))

```Swift
List(selection: $selection) {
  ForEach(0...100, id: \.self) { idx in
    NavigationLink(value: idx) { Text("\(idx)" }
  }
}
.navigationDestination(for: Int.self) { value in ... } // if you use List(selection: $selection), navigationDestination isn't called.
.onChange(of: selection) { newValue in ... ) 
```
## Examples

- iOS 16.0+
- Xcode 14.0

## Simple Exmample


```Swift
import NavigationDestinationSelectedViewModifier

List(selection: $selection) {
  ForEach(0...100, id: \.self) { idx in
    NavigationLink(value: idx) { Text("\(idx)" }
  }
}
.navigationDestination(selected: $selection) { value in Text("\(value)" }
.onChange(of: selection) { newValue in ... )
```

## Data Convertion Example

```Swift
import NavigationDestinationSelectedViewModifier

var body: some View {
    List(selection: $selection) {
        ForEach(0...10, id: \.self) { idx in
            cell(idx: idx)
        }
    }
    .disabled(isProgressing)
    .navigationDestination(selection: $selection, item: $convertedData) { item in
        Text("converted \(item)")
    }
    .onChange(of: selection) { newValue in
        guard let newValue = newValue else { return }
        self.isProgressing = true
        
        // data loading or data converting ...
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.convertedData = "\(newValue + 1000)"
            self.isProgressing = false
        }
    }
}
    
private func cell(idx: Int) -> some View {
    NavigationLink(value: idx) {
        HStack {
            if isProgressing && selection == idx {
                ProgressView()
            } else {
                ProgressView()
                    .hidden()
            }
            Text("\(idx)")
        }
    }
}
```

## PlainFileList

```swift
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

```

## Note

View transition by navigationDestination(selected:) won't update $path in NavigationLink(path: $path).

