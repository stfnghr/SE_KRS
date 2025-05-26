//
//  ActivityView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 26/05/25.
//

import SwiftUI

struct ActivityView: View {
    @State private var selectedIndex = 0
    let options = ["On Process", "History"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255)
                    .ignoresSafeArea(.all)
                
                VStack {
                    Text("Your Activity")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    Picker("", selection: $selectedIndex) {
                        ForEach(0..<options.count, id: \.self) { index in
                            Text(options[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            if selectedIndex == 0 {
                                NavigationLink(destination: OnProcessView()) {
                                    ActivityCardView()
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                NavigationLink(destination: HistoryView()) {
                                    ActivityCardView()
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
        } .tint(.orange)
    }
}

#Preview {
    ActivityView()
}
