analyze_result() {
    if [ $? -ne 0 ]; then
        echo "Found code issues during analysis, fix them before building"
        exit 1
    fi
}

# Analyze the code
flutter analyze
analyze_result

# Clean previous build (optional)
flutter clean

# Build the app in release mode
flutter build apk --release

# Display success message
echo "flutter app built successfully"
