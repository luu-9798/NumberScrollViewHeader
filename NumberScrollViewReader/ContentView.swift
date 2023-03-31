//
//  ContentView.swift
//  NumberScrollViewReader
//
//  Created by Trung Luu on 3/31/23.
//

import SwiftUI

struct NumberedTextView: View, Identifiable {
    let id = UUID()
    let number: Int
    
    var body: some View {
        Text("Number \(number)")
            .id(id)
            .padding()
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct ContentView: View {
    let numbers = Array(1...50)
        
    var body: some View {
        VStack {
            
            ScrollViewReader { proxy in
                Button("Jump to 25") {
                    withAnimation {
                        proxy.scrollTo(numbers[24])
                    }
                }
                ScrollView {
                    LazyVStack {
                        ForEach(numbers, id: \.self) { number in
                            NumberedTextView(number: number)
                                .background(number % 2 == 0 ? Color.gray : Color.white)
                        }
                    }
                    .onAppear {
                        proxy.scrollTo(numbers[24])
                    }
                    .onChange(of: numbers) { _ in
                        proxy.scrollTo(numbers[24])
                    }
                    .background(GeometryReader { geo in
                        Color.clear
                            .preference(key: ViewOffsetKey.self, value: geo.frame(in: .global).minY)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) { offset in
                        print("Offset: \(offset)")
                    }
                }
                .coordinateSpace(name: "scrollView")
                .background(Color.yellow)
                .overlay(
                    Text("This is an overlay")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                )
                .onAppear {
                    proxy.scrollTo(numbers[24])
                }
                .backgroundPreferenceValue(ViewOffsetKey.self) { offset in
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: ViewOffsetKey.self, value: proxy.frame(in: .global).minY)
                    }
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
