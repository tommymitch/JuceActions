#!/bin/bash
echo Building the Projucer
git clone https://github.com/tommymitch/JuceActions.git
git clone --branch 6.0.7 https://github.com/juce-framework/JUCE.git
XCODE_PROJECT="JUCE/extras/Projucer/Builds/MacOSX/Projucer.xcodeproj"
SDK=macosx
SCHEME="Projucer - App"
xcodebuild -sdk $SDK -project "$XCODE_PROJECT" -scheme "$SCHEME" -configuration Release install -jobs 8
PROJUCER_PATH="JUCE/extras/Projucer/Builds/MacOSX/Build/Release/Projucer.app/Contents/MacOS/Projucer"

echo "Creating JuceActions xcode project..."
PROJUCER_PROJECT_PATH="JuceActions/JuceActions.jucer"
./$PROJUCER_PATH --resave $PROJUCER_PROJECT_PATH

echo "Building JuceActions"
XCODE_PROJECT="JuceActions/Builds/MacOSX/JuceActions.xcodeproj"
SCHEME="JuceActions - App"

BUILD_PATH="JuceActions/Builds/MacOSX/build/Release"
BUILD_DESTINATION="$BUILD_PATH/JuceActions.xcarchive"

xcodebuild -sdk $SDK -project "$XCODE_PROJECT" -scheme "$SCHEME" -configuration Release archive -archivePath "$BUILD_DESTINATION" -jobs 8

# -------------------------------------------------------
# copy app to a more useful folder
echo "Copying JuceActions.app..."
if [ ! -d "$BUILD_PATH/deployment" ]; then
  mkdir $BUILD_PATH/deployment
fi

cp -r  $BUILD_DESTINATION/Products/Users/$USER/Applications/JuceActions.app $BUILD_PATH/deployment/JuceActions.app