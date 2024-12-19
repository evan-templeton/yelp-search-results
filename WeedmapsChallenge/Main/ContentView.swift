//
//  ContentView.swift
//  WeedmapsChallenge
//
//  Created by Evan Templeton on 11/29/24.
//  Copyright © 2024 Weedmaps, LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var nearbyViewModel = NearbyViewModel(searchService: YelpSearchService())
    
    var body: some View {
        NearbyView(viewModel: nearbyViewModel)
    }
}
