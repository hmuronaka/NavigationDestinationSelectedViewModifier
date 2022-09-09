//
//  MultiSectionList.swift
//  NavigationStackSample
//
//  Created by MuronakaHiroaki on 2022/09/10.
//

import SwiftUI
import NavigationDestinationSelectedViewModifier

fileprivate struct Cell<T: Hashable>: View {
    
    let value: T
    @State private var isChecked = false
    var body: some View {
        NavigationLink(value: value) {
            HStack {
                Text("\(String(describing: value))")
                Spacer()
                Button() {
                    isChecked.toggle()
                } label: {
                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                }
                .buttonStyle(.borderless)
            }
        }
        .contentShape(Rectangle())
    }
}
 

fileprivate struct IntSection: View {
    let data = [0, 10, 20]
    @Binding var selected: Int?
    
    var body: some View {
        Section {
            ForEach(data, id: \.self) { val in
                Cell(value: val)
                    // NOTE 以下を利用してもNavigationLinkにtap eventは伝播しなかった.
                    //      またNavigationLink内のボタン等のactionも同時に呼ばれるので、
                    //      .simultaneousGestureの利用は適切でない。
                    // .simultaneousGesture(TapGesture(count: 1).onEnded({}))
                    .onTapGesture {
                        self.selected = val
                    }
            }
        } header: {
            Text("Int")
        }
    }
}

fileprivate struct StringSection: View {
    let data = ["A", "B", "C"]
    @Binding var selected: String?
    
    var body: some View {
        Section {
            ForEach(data, id: \.self) { val in
                Cell(value: val)
                    .onTapGesture {
                        self.selected = val
                    }
            }
        } header: {
            Text("String")
        }
    }
}

struct MultiSectionList: View {
    
    @State private var selectedInt: Int?
    @State private var selectedStr: String?
    
    var body: some View {
        List {
            IntSection(selected: $selectedInt)
            StringSection(selected: $selectedStr)
        }
        .onChange(of: selectedInt) { newValue in
            NSLog("changed: \(String(describing: newValue))")
        }
        .onChange(of: selectedStr) { newValue in
            NSLog("changed: \(String(describing: newValue))")
        }
        .navigationDestination(selected: $selectedInt) { val in
            Text("int - \(val)")
        }
        .navigationDestination(selected: $selectedStr) { val in
            Text("str - \(val)")
        }
    }
    
   
    
}

struct MultiSectionList_Previews: PreviewProvider {
    static var previews: some View {
        MultiSectionList()
    }
}
