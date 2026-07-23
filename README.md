# TeslaUI

Tesla Model S UI Recreation with Qt, QML and C++

## Overview

This project is a faithful recreation of the Tesla Model S user interface using Qt, QML, and C++. It demonstrates modern UI design patterns, real-time data visualization, and interactive components.

## Features

- **Vehicle Controls**: Open/close trunk, lock/unlock, and other vehicle functions
- **Navigation Map**: Integrated map view with real-time location tracking and route planning
- **Status Dashboard**: Display of battery level, speed, temperature, and vehicle status
- **User Profile**: Quick access to driver information and preferences
- **Media Controls**: Spotify and other media playback controls with currently playing information
- **Climate Control**: Temperature and climate settings
- **Tire Pressure Monitoring**: Real-time tire pressure information for all wheels
- **Route Navigation**: Multiple route options with distance and time estimates
- **Responsive Design**: Adaptive UI that works across different screen resolutions

## Technology Stack

- **Qt Framework**: For cross-platform UI development
- **QML**: For declarative UI design
- **C++**: For business logic and performance-critical components
- **CMake**: Build system for cross-platform compilation

## Screenshots

### Main Dashboard with Navigation
<img width="1275" height="749" alt="Captura de pantalla 2026-07-23 122639" src="https://github.com/user-attachments/assets/fda5acbd-3d44-404f-a060-fbd490e6503b" />

### Navigation with Route Planning
<img width="1280" height="741" alt="Captura de pantalla 2026-07-23 121754" src="https://github.com/user-attachments/assets/d7dc127c-2aa4-4793-a2c0-10e4090bd550" />

The interface showcases a modern, minimalist design with intuitive navigation and real-time data displays. Features include:
- Interactive map with search functionality
- Speed display and vehicle charging status
- Multiple route options visualization
- Real-time tire pressure monitoring
- Music player integration with currently playing track information

## Recent Updates

- ✅ Enhanced map integration with search functionality
- ✅ Route planning with multiple alternatives
- ✅ Tire pressure monitoring system
- ✅ Improved UI responsiveness
- ✅ Better real-time data visualization

## Getting Started

### Prerequisites

- Qt 5.15+ or Qt 6.x
- C++ 17 or later
- CMake 3.16+

### Building

```bash
git clone https://github.com/Josemaik/TeslaUI.git
cd TeslaUI
mkdir build
cd build
cmake ..
make
./TeslaUI
```

## Project Structure

- `/src` - C++ source code
- `/qml` - QML interface files
- `/resources` - Images, icons, and other resources
- `/docs` - Documentation and screenshots

## License

This project is provided as-is for educational and demonstration purposes.

## Contributing

Feel free to fork this project and submit pull requests with improvements or additional features.
