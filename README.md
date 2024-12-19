# Yelp Search Results

This is an iOS app that uses the Yelp Fusion API to fetch and display search results for businesses based on user input. The app leverages Swift, SwiftUI, and Concurrency.

## Features

- **Search Businesses:** Enter keywords to search for businesses on Yelp.
- **Business Details:** View essential information such as name, rating, price range, and category.
- **Image Display:** Fetch and display images of businesses directly from the API.
- **Modern UI:** Designed with SwiftUI to ensure a clean and user-friendly interface.

## Screenshots

Add screenshots here to showcase the app's UI and functionality.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/evan-templeton/yelp-search-results.git
   ```
2. Navigate to the project directory:
   ```bash
   cd yelp-search-results
   ```
3. Open the project in Xcode:
   ```bash
   open YelpSearchResults.xcodeproj
   ```
4. Build and run the app on a simulator or connected device.

## Usage

1. Launch the app.
2. Enter a search term (e.g., "restaurants" or "coffee") in the search bar.
3. Browse the results displayed on the screen.
4. Tap on a business to view additional details.

## Configuration

To use the Yelp Fusion API, you need an API key. Follow these steps:

1. Sign up for a Yelp Developer account and create a new app to get your API key: [Yelp Developers](https://www.yelp.com/developers)
2. Add your API key to the project:
   - Open the `Constants.swift` file.
   - Replace the placeholder with your API key:
     ```swift
     static let yelpAPIKey = "YOUR_API_KEY_HERE"
     ```

## Technologies Used

- **Language:** Swift
- **Framework:** SwiftUI
- **Concurrency:** Swift Concurrency (async/await)
- **Networking:** URLSession
- **API:** Yelp Fusion API

## Acknowledgments

- [Yelp Fusion API](https://www.yelp.com/developers/documentation/v3) for providing the business data.
- Inspiration from modern search apps.

---
