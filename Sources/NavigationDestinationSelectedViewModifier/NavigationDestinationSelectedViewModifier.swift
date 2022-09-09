import SwiftUI

@available(iOS 16.0, macOS 13.0, *)
fileprivate struct NavigationDestinationViewModifier<SelectionValue: Hashable, Value: Equatable, Destination: View>: ViewModifier {
    
    @Binding var selection: SelectionValue?
    @Binding var item: Value?
    @ViewBuilder let destination: (Value) -> Destination
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(isPresented: .init(get: {
                item != nil
            }, set: { newValue in
                if !newValue {
                    item = nil
                }
            })) {
                if let selected = item {
                    destination(selected)
                } else {
                    EmptyView()
                }
            }
            .onChange(of: item) { newValue in
                if newValue == nil && selection != nil {
                    selection = nil
                }
            }
    }
}

@available(iOS 16.0, macOS 13.0, *)
public extension View {
    func navigationDestination<SelectionValue: Hashable, Value: Equatable, Destination: View>(selection: Binding<SelectionValue?>, item: Binding<Value?>, @ViewBuilder destination: @escaping (Value) -> Destination) -> some View {
        return self.modifier(NavigationDestinationViewModifier(selection: selection, item: item, destination: destination))
    }
    
    func navigationDestination<Value: Equatable & Hashable, Destination: View>(selected: Binding<Value?>, @ViewBuilder destination: @escaping (Value) -> Destination) -> some View {
        return self.modifier(NavigationDestinationViewModifier(selection: selected, item: selected, destination: destination))
    }
}
