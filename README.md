# Keepsake: A Slow Messaging Platform 

## How to Run the App  
To experience the **Keepsake** prototype on your own device or the simulator, follow these steps:

### 1. Prerequisites
* **Mac** running macOS Ventura (13.0) or later.
* **Xcode 14.0+** installed.
* **iPhone** (optional) running iOS 16.0+.

### 2. Installation & Setup
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/rebeccaschou/keepsake

2. Open the Project:
Navigate to the project folder and open Keepsake.xcodeproj.

3. Select a Target:
In the top toolbar of Xcode, select an iPhone Simulator (iPhone 16 Pro recommended).

### 3. Launching the App
1. Press Cmd + R or click the Play button in the top left corner. The app will launch directly into the Main Camera View.

## File Structure
```text
Keepsake/
├── App/
│   └── KeepsakeApp.swift        # Entry point and EnvironmentObject injection
├── Models/
│   ├── Keepsake.swift           # The core keepsake data model 
│   └── AppModel.swift           # Enum for state-driven navigation 
├── Views/
│   ├── ContentView.swift        # Root router (switches between camera, creation, and collection)
│   ├── CameraView.swift         # In-app camera viewfinder and shutter logic
│   ├── CreationView.swift       # Multi-step keepsake creation flow
│   ├── CollectionView.swift     # Collection view of all received keepsakes 
│   └── DetailView.swift         # Full-screen keepsake viewer with image, caption, and metadata
├── Services/
│   ├── StorageManager.swift     # Archival logic: PDF conversion and text parsing
│   └── KeepsakeStore.swift      # The runtime \"Source of Truth\" (ObservableObject)
└── Assets/
