# Home Assignment for WSCSport 🏆

## Overview

This assignment aims to build a mini “score” application that can display a story for each match.

A URL is provided to fetch the response containing a feed of matches with their highlights. (Do not add the JSON file to your Xcode project.)

The app provides the following main capabilities:

1. Displays all the matches and scores sectioned by leagues (mock design provided for reference, but not mandatory to follow).
2. Clicking on a match opens a **horizontal-based player** (similar to Instagram Stories), displaying relevant video pages[].

### Guidelines Implemented:

- Used only **Kingfisher** via SPM for image fetching.
- Filtered out games without a `wscGame` property.
- Filtered out all data without a `primeStory`.
- Extracted the final score from the last page in the `pages` array of `wscGame`.

## Implementation Details

- **UIKit as Root Application**: The main app structure is built using UIKit.
- **SwiftUI for Leagues & Scores**: The leagues and scores listing screen is implemented using SwiftUI.
- **UIKit for Stories Player**: The match highlights player is built using UIKit.

## Technology Stack

- **UIKit & SwiftUI**: Hybrid UI approach.
- **MVVM**: Clean architecture pattern for better separation of concerns.
- **Kingfisher**: Used for efficient image loading.
- **URLSession**: Handles API calls efficiently.

## Screenshots

| Screen 1 | Screen 2 | Screen 3 |
| -------- | -------- | -------- |
| ![Screen 1](https://github.com/user-attachments/assets/5fae2eeb-b956-45dd-b165-46fea737a04e) | ![Screen 2](https://github.com/user-attachments/assets/f9c59aaf-5c29-4d64-8fb2-5bc431cec891) | ![Screen 3](https://github.com/user-attachments/assets/021ca305-92c7-49dc-b340-37cef9fff8a6) |

## **Developed By**

**Diana Nareiko**  
Email: diananareiko8@gmail.com  
GitHub: [https://github.com/diananareiko](https://github.com/diananareiko)

