//
//  InputView.swift
//  WeedmapsChallenge
//
//  Created by Evan Templeton on 11/29/24.
//  Copyright © 2024 Weedmaps, LLC. All rights reserved.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let placeholder: String
    let image: Image?
    let imagePlacement: HorizontalEdge
    let placeholderAsHeader: Bool
    let lines: Int
    @State private var textHeight = 0.0
    
    init(text: Binding<String>,
         placeholder: String,
         image: Image? = nil,
         imagePlacement: HorizontalEdge = .trailing,
         placeholderAsHeader: Bool = true,
         lines: Int = 1
    ) {
        self._text = text
        self.placeholder = placeholder
        self.image = image
        self.imagePlacement = imagePlacement
        self.placeholderAsHeader = placeholderAsHeader
        self.lines = lines
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    if imagePlacement == .leading {
                        image?
                            .resizable()
                            .scaledToFit()
                            .frame(width: textHeight, height: textHeight)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        if placeholderAsHeader && !text.isEmpty {
                            Text(placeholder)
                                .font(.regular12)
                                .foregroundColor(.gray6)
                                .fixedSize()
                        }
                        TextField("", text: $text, axis: lines > 1 ? .vertical : .horizontal)
                            .multilineTextAlignment(.leading)
                            .lineLimit(lines, reservesSpace: lines > 1)
                            .placeholder(when: text.isEmpty, alignment: .topLeading) {
                                Text(placeholder)
                                    .font(.regular16)
                                    .foregroundColor(.gray6)
                                    .readSize { size in
                                        textHeight = size.height
                                    }
                            }
                            .font(.regular16)
                            .foregroundColor(.gray7)
                    }
                    
                    Spacer()
                    if imagePlacement == .trailing {
                        image?
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: textHeight, maxHeight: textHeight)
                    }
                }
                .padding(.vertical, !text.isEmpty && placeholderAsHeader ? 5 : 15)
                
                Divider()
                    .background(Color.gray5)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

private extension View {
    func placeholder<Content: View>(when shouldShow: Bool,
                                    alignment: Alignment = .leading,
                                    @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0).fixedSize()
            self
        }
    }
}
