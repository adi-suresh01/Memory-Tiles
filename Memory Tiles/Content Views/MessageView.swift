//
//  MessageView.swift
//  Memory Tiles
//
//  Created by adi on 2/23/25.
//
import SwiftUI
import UIKit

struct ToastView: View {
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Spacer() // Pushes the toast to the bottom
            Text(message)
                .font(.custom("Chalkboard SE", size: 20))
                .foregroundColor(.red)
                .padding()
                .background(Color.black.opacity(0))
                .cornerRadius(10)
                .padding(.bottom, 50) // Extra space from bottom edge
        }
        .onAppear {
            // Hide automatically after 1.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    onDismiss()
                }
            }
        }
    }
}
