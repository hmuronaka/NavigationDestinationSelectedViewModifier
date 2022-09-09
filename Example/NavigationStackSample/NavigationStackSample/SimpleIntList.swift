//
//  IntList.swift
//  NavigationStackSample
//
//  Created by MuronakaHiroaki on 2022/09/09.
//

import SwiftUI
import NavigationDestinationSelectedViewModifier

struct SimpleIntList: View {
    var highlight: Int?
    @State private var selectedIndex: Int? = nil
    
    var body: some View {
        List(selection: $selectedIndex) {
            ForEach(0...100, id: \.self) { idx in
                NavigationLink(value: idx) {
                    Text("\(idx)")
                        .foregroundColor(highlight == idx ? .accentColor : .primary)
                }
            }
        }
        .navigationTitle(highlight != nil ? "\(highlight!)" : "")
        .navigationDestination(selected: $selectedIndex) { selected in
            SimpleIntList(highlight: selected)
        }
        .onChange(of: selectedIndex) { newValue in
            NSLog("newValue: \(String(describing: newValue))")
        }
    }
}

struct IntList_Previews: PreviewProvider {
    static var previews: some View {
        SimpleIntList()
    }
}
