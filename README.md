
# Angel Hack Challenge Solution - Digital Empowerment - EduChain

![https://github.com/Jlisowskyy/AngelHack_solution/win.jpg](https://github.com/Jlisowskyy/AngelHack_solution/blob/main/win.jpg)

## Overview

Welcome to the EduChain App, a revolutionary platform designed to enhance learning through short, engaging video content. Our application, which secured second place in the "Digital Empowerment" category at the AngelHack hackathon, aims offer digestable educationalcontent in a format inspired by TikTok but with significant differences.

## Problem Statement

In today's fast-paced digital world, our attention span is rapidly decreasing due to the influx of brief, fragmented content. While this trend might not significantly impact many daily activities, it poses a considerable challenge for learning and personal development. Our solution addresses this issue by providing a platform for buying and watching educational courses entirely presented as very short videos.

## Solution

Our app offers an innovative approach to learning by presenting courses through short, engaging videos, akin to TikTok. However, our content is exclusively educational. The app has two main features:

1. **Homepage**: Users can swipe through free short video previews of various courses. The content displayed here is guided by a content-matching algorithm to enhance user experience and engagement.

2. **Purchased Content Page**: Users can swipe through the short videos of the courses they have purchased. This section offers a personalized viewing experience, allowing users to tailor their learning journey.

### Key Features

- **Cryptocurrency Payments**: All transactions within the app are conducted using cryptocurrencies.
- **User Identification**: Users are identified through their crypto wallets.
- **Blockchain Integration**: The blockchain enables the exchange of course access and ownership.
- **AI-Powered Content Creation**: Our platform supports content creators with advanced AI tools to generate high-quality educational material.

## Technologies Used

- **Frontend**: Flutter
- **Backend**: Python, 
- **Blockchain**: Solidity

## Demo

Watch our short demo video to see the app in action:

[output.webm](https://github.com/Jlisowskyy/AngelHack_solution/assets/115403674/cafde24f-cf8b-4f4f-967a-5ba1421d4f46)

## Setup Instructions

Before you begin, ensure you have the following installed:
- **Flutter SDK**: Install the latest version of Flutter on your PC from [Flutter's official website](https://flutter.dev).

1. **Clone the Repository**: 
   Start by cloning the app repository to your local machine. Use the following commands to clone and navigate into the project directory:
   ```bash
   git clone https://github.com/Jlisowskyy/AngelHack_solution.git
   cd AngelHack_solution/frontend
   ```

2. **Install Dependencies**:
   Fetch and install the project dependencies by running:
   ```bash
   flutter pub get 
   ```

3. **Enable Web Support**:
   Verify that web support is enabled by checking the available devices:
   ```bash
   flutter devices
   ```

   Ensure that Chrome and the web server are listed as available devices for the best experience.

4. **Run the Application**:
   Launch the application in a Chrome browser by executing:
   ```bash
   flutter run -d chrome --release
   ```
   Or use other viable environment
