//
//  DataConvertList.swift
//  NavigationStackSample
//
//  Created by MuronakaHiroaki on 2022/09/09.
//

import SwiftUI
import NavigationDestinationSelectedViewModifier

struct DataConvertList: View {
    @State private var selection: Int?
    @State private var convertedData: String?
    @State private var isProgressing = false
    
    var body: some View {
        List(selection: $selection) {
            Section {
                ForEach(0...10, id: \.self) { idx in
                    cell(idx: idx)
                }
            } header: {
                Text("0 ~ 10")
            }
        }
        .disabled(isProgressing)
        .navigationDestination(selection: $selection, item: $convertedData) { item in
            Text("converted \(item)")
        }
        .onChange(of: convertedData) { newValue in
            NSLog("convertedData: \(String(describing: newValue))")
        }
        .onChange(of: selection) { newValue in
            NSLog("selection: \(String(describing: newValue))")
            guard let newValue = newValue else { return }
            self.isProgressing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.convertedData = "\(newValue + 1000)"
                self.isProgressing = false
            }
        }
    }
    
    @ViewBuilder
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
                    .foregroundColor(.primary)
            }
        }
        .listRowBackground(selection == idx ? Color(uiColor: .systemGray4) : Color(uiColor: .systemBackground))
    }
    
}

struct DataConvertList_Previews: PreviewProvider {
    static var previews: some View {
        DataConvertList()
    }
}
