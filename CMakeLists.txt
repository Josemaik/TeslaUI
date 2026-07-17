cmake_minimum_required(VERSION 3.16)

project(TeslaUI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Positioning Location)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(appTeslaUI
    main.cpp
)

qt_add_qml_module(appTeslaUI
    URI TeslaUI

    QML_FILES
        Main.qml
        ui/Views/BottomBar.qml
        ui/Views/RightScreen.qml
        ui/Views/LeftScreen.qml
        ui/Components/NavigationSearchBox.qml
        ui/Components/HVACComponent.qml
        ui/Components/VolumeControlComponent.qml
        ui/Components/ApptabComponent.qml

    SOURCES
        Controllers/system.h
        Controllers/system.cpp
        Controllers/hvachandler.h
        Controllers/hvachandler.cpp
        Controllers/audiocontroller.h
        Controllers/audiocontroller.cpp
        Controllers/appcontroller.h
        Controllers/appcontroller.cpp
)
qt_add_resources(appTeslaUI Resource
    PREFIX "/"
    BASE Resources
    FILES
        Resources/assets/arcadeIcon.jpg
        Resources/assets/cameraIcon.png
        Resources/assets/car_front_icon.png
        Resources/assets/carRender2.0.jpg
        Resources/assets/heatedseats.png
        Resources/assets/lockIcon.png
        Resources/assets/MapIcon.png
        Resources/assets/MultimediaIcon.png
        Resources/assets/phoneIcon.png
        Resources/assets/searchIcon.png
        Resources/assets/spotifyIcon.png
        Resources/assets/unlockIcon.png
        Resources/assets/userIcon.png
        Resources/assets/volume1.png
        Resources/assets/volume2.png
        Resources/assets/volumemutted.png
)



# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appTeslaUI PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appTeslaUI
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appTeslaUI
    PRIVATE Qt6::Quick
    Qt6::Positioning
    Qt6::Location
)

install(TARGETS appTeslaUI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
