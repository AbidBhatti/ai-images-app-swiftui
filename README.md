# ImagifAi-SwiftUI

<img src="https://github.com/AbidBhatti/ai-images-app-swiftui/blob/main/Artefacts/ImagifAi.png?raw=true"/>


A modern iOS demo app showcasing OpenAI's DALL·E image generation API integration. Users can input text prompts and receive AI-generated images in real time.

---

## 📝 Overview

**ImagifAi-SwiftUI** is a SwiftUI-based iOS application that demonstrates how to integrate OpenAI's image generation API (DALL·E). The app allows users to:

- Enter a text prompt describing an image.
- Select the DALL·E model and image resolution.
- Generate one or more AI-created images based on the prompt.
- View, save, and revisit previously generated images.

This project is intended as a reference for developers interested in building AI-powered image generation features into their own iOS apps.

---

##  📱 Screenshots
<img src="https://github.com/AbidBhatti/ai-images-app-swiftui/blob/main/Artefacts/HomePage.png?raw=true" width="380" height="800"/> &nbsp; <img src="https://github.com/AbidBhatti/ai-images-app-swiftui/blob/main/Artefacts/GenerationResultView.png?raw=true" width="380" height="800"/> <img src="https://github.com/AbidBhatti/ai-images-app-swiftui/blob/main/Artefacts/CollectionView.png?raw=true" width="380" height="800"/>

## 🛠️ Tech Stack

- **Swift 5 / SwiftUI** – Declarative UI framework for iOS.
- **OpenAI API (DALL·E)** – For AI image generation.
- **async/await** – For modern asynchronous networking.
- **SwiftData** – For local persistence of generated images.
- **ABNetworking** – Lightweight networking abstraction (local package).
- **Photos Framework** – For saving images to the user's photo library.

---

## 🚀 Getting Started

### Prerequisites

- **Xcode 16** or later
- **iOS 18** or later
- An **OpenAI API key** (see below)

### Installation

1. **Clone the repository:**
   ```sh
   https://github.com/AbidBhatti/ai-images-app-swiftui
   cd ai-images-app-swiftui
   ```

2. **Open the project in Xcode:**
   - Double-click `ImagifAi-SwiftUI.xcodeproj`.

3. **Install dependencies:**
   - There are no third party dependencies, just a local dependency module for networking. Xcode will resolve it automatically.

---

## 🔑 OpenAI API Key Setup

1. **Get your API key:**
   - Sign up or log in at [OpenAI](https://platform.openai.com/account/api-keys).
   - Create a new API key.

2. **Insert your API key:**
   - Open `ImagifAi-SwiftUI/Config/Config.swift`.
   - Replace the value of `OPEN_AI_API_KEY` with your own key:
     ```swift
     enum Config {
         static let OPEN_AI_API_KEY = "API_KEY"
     }
     ```
---

## 📱 How to Use

1. **Build and run the app** on a simulator or device.
2. **Generate Images:**
   - Go to the **Generate Image** tab.
   - Enter a descriptive prompt (e.g., "A futuristic cityscape at sunset").
   - Select the DALL·E model and image resolution.
   - Choose the number of images to generate.
   - Tap **Generate**.
3. **View Results:**
   - Generated images will appear in a detail view.
   - You can save images to your device or revisit them in the **Saved Generations** tab.

---

## 📂 Folder Structure

```
ImagifAi-SwiftUI/
├── Config/         # API key and configuration
├── Constants/      # UI strings and constants
├── Helpers/        # Utility functions
├── Layout/         # Custom layout views
├── Models/         # Data models (Prompt, Image, etc.)
├── Service/        # OpenAI API integration
├── ViewModels/     # State and business logic
├── Views/          # SwiftUI views (UI)
│   └── Tabs/       # Main app tabs (Generate, Collection)
├── Assets.xcassets # Image and color assets
```

---

## ⚠️ Known Limitations / Future Enhancements

- **API Key Security:** The API key is currently stored in plain text for demo purposes. Use secure storage for production.
- **Error Handling:** Basic error alerts are shown; more robust handling and user feedback could be added.
- **Customization:** Only DALL·E 2 and 3 models are supported; future versions may add more options or fine-tuning.

---

## 📄 License

This project is for demonstration and educational purposes. No explicit license is included.

---

## 🔗 Useful References

- [OpenAI DALL·E API Documentation](https://platform.openai.com/docs/guides/images)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [OpenAI API Key Management](https://platform.openai.com/account/api-keys)

---

**Enjoy generating AI-powered images on iOS!**
