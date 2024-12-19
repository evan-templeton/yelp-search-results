//
//  Fonts.swift
//  WeedmapsChallenge
//
//  Created by Evan Templeton on 11/29/24.
//  Copyright © 2024 Weedmaps, LLC. All rights reserved.
//

import struct SwiftUI.Font

extension Font {
    static var regular12: Font {
        Font.system(size: 12)
    }
    
    static var regular16: Font {
        Font.system(size: 16)
    }
    
    static var semibold18: Font {
        Font.system(size: 18, weight: .semibold)
    }
    
    static var bold22: Font {
        Font.system(size: 22, weight: .bold)
    }
}
