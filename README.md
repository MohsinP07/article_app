# Flutter Article App
A Flutter app that fetches and displays a list of articles from a public
API.

## Features
- List of articles
- Search functionality
- Detail view
- Responsive UI

## Setup Instructions
1. Clone the repo:
   git clone https://github.com/MohsinP07/article_app.git
   cd flutter_article_app
   flutter pub get
   flutter run

## Tech Stack
- Flutter SDK
- State Management: Provider
- HTTP Client: http
- Persistence: hive

## State Management Explanation
This app uses the `provider` package for state management. `ArticleProvider` holds the state for articles, favorites, and loading/error states. Widgets listen to the provider and automatically rebuild when the data updates, ensuring a reactive and clean data flow.

## Known Issues / Limitations
- No offline storage implemented (articles are fetched every time).
- Basic UI; can be enhanced with images, categories, and pagination.
- Favorites are not persisted between app restarts.
