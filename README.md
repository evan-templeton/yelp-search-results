# Yelp Search Results

This is an iOS app that uses the Yelp Fusion API to fetch and display search results for businesses based on user input. The app leverages Swift, SwiftUI, and Concurrency.

## Features

- **Search Businesses:** Enter keywords to search for businesses on Yelp.
- **Business Details:** View essential information such as name, rating, price range, and category.
- **Image Display:** Fetch and display images of businesses directly from the API.
- **Modern UI:** Designed with SwiftUI to ensure a clean and user-friendly interface.

## Screenshots

<img src="https://github.com/user-attachments/assets/5133173d-40eb-4445-8831-b82caae88885" alt="Main Screen" width="300">
<img src="https://github.com/user-attachments/assets/62f3ca39-d5bb-481a-a588-21c6198bf1fe" alt="Main Screen" width="300">
<img src="https://github.com/user-attachments/assets/0d6bedc2-df2e-40e1-b8a4-f8061f280afc" alt="Main Screen" width="300">
<img src="https://github.com/user-attachments/assets/3a85b35e-1717-4cf7-866e-c5eb8d08cc82" alt="Main Screen" width="300">
<img src="https://github.com/user-attachments/assets/df9a27a3-80f8-4d6e-9a66-ee7ccda1ea75" alt="Main Screen" width="300">


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
