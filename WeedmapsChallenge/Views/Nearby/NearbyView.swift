//
//  Copyright © 2024 Weedmaps, LLC. All rights reserved.
//

import UIKit
import SwiftUI

struct NearbyView: View {
    
    @ObservedObject var viewModel: NearbyViewModel
    
    @State private var showError = false
    @State private var showBusinessAlert = false
    @State private var showBusinessWebView = false
    
    @State private var businessTapped: Business?
    
    @State private var headerHeight = 0.0 // reference for self-sizing images
    
    var body: some View {
        VStack {
            header
            InputView(text: $viewModel.searchInput,
                      placeholder: "Search for a place in \(viewModel.city)",
                      image: Image(systemName: "magnifyingglass"),
                      imagePlacement: .leading)
            .autocorrectionDisabled()
            .accessibilityIdentifier("searchInputField")
            Spacer()
            if !viewModel.suggestions.isEmpty {
                suggestionsList
            } else if !viewModel.businesses.isEmpty {
                businessesList
            } else {
                ContentUnavailableView(
                    "Yelp Business Search",
                    systemImage: "magnifyingglass",
                    description: Text("Use the search bar above to find nearby businesses")
                )
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $showBusinessWebView) {
            if let url = businessTapped?.url {
                WebView(url: url)
            }
        }
        .onChange(of: viewModel.errorMessage) {
            showError = viewModel.errorMessage != nil
        }
        .alert("Error", isPresented: $showError, actions: {
            Button("OK", role: .cancel) {
                showError = false
            }
        }, message: {
            Text(viewModel.errorMessage ?? "Unknown Error")
        })
        .alert(businessTapped?.name ?? "Open Business Details", isPresented: $showBusinessAlert, actions: {
            if let url = businessTapped?.url {
                Link("Open in Safari", destination: url)
            }
            Button("Open in Webview") { showBusinessWebView = true }
            Button("Cancel", role: .cancel) {
                showBusinessAlert = false
                businessTapped = nil
            }
        })
    }
    
    private var header: some View {
        HStack {
            Text("Find a Business")
                .font(.bold22)
                .readSize { size in
                    headerHeight = size.height
                }
            Spacer()
            Button(action: viewModel.requestLocation) {
                Label("Current Location", systemImage: "location")
                    .fixedSize()
                    .padding(10)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.white)
            }
        }
    }
    
    private var suggestionsList: some View {
        List {
            ForEach(viewModel.suggestions, id: \.self) { suggestion in
                Button {
                    Task {
                        await viewModel.getBusinesses(input: suggestion)
                        await MainActor.run {
                            viewModel.searchInput = ""
                            viewModel.suggestions = []
                            dismissKeyboard()
                        }
                    }
                } label: {
                    Text(suggestion)
                        .accessibilityIdentifier("suggestion")
                }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.never)
    }
    
    private var businessesList: some View {
        List {
            ForEach(viewModel.businesses) { business in
                Button {
                    dismissKeyboard()
                    businessTapped = business
                    showBusinessAlert = true
                } label: {
                    HStack {
                        AsyncImage(url: business.imageURL) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .frame(width: headerHeight * 3, height: headerHeight * 3)
                                    .scaledToFit()
                            } else {
                                ProgressView()
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(business.name)
                                .font(.semibold18)
                                .lineLimit(3, reservesSpace: true)
                            Text(String(business.rating) + " Stars")
                                .font(.regular16)
                        }
                    }
                }
                .accessibilityIdentifier("business")
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.never)
    }
}

#Preview {
    NearbyView(viewModel: NearbyViewModel(searchService: SearchServiceMock()))
}
