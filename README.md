# Chhoti Jagah - Flutter App Structure

This document outlines the organized and modular structure of the Chhoti Jagah Flutter application.

## Directory Structure

### 📁 `config/`
Application configuration files including themes, text configurations, and Firebase setup.

### 📁 `constants/`
Application-wide constants and configuration values.

### 📁 `l10n/`
Localization files for multiple languages (Bengali, English, Hindi, Kannada, Marathi, Odia, Tamil, Telugu).

### 📁 `models/`
Data models and classes used throughout the application.

### 📁 `screens/`
UI screens organized by feature:
- **`onboarding/`**: Splash screen and language selection
- **`main/`**: Main application screens (home, etc.)

### 📁 `services/`
Business logic and external service integrations:
- Language storage service
- Firebase services
- App initialization

### 📁 `state_management/`
State management using Riverpod:
- **`providers/`**: Feature-specific providers (language, theme)

### 📁 `utils/`
Common utilities and helper functions:
- Constants
- Extensions
- Helper methods

### 📁 `widgets/`
Reusable UI components organized by purpose:
- **`ui_components/`**: Basic UI elements (buttons, inputs)
- **`form_components/`**: Form-specific widgets
- **`layout_components/`**: Layout and structural components

## Key Features

### 🎨 **Modular Design**
- Each component has a single responsibility
- Clear separation of concerns
- Easy to maintain and extend

### 🔄 **State Management**
- Centralized state management with Riverpod
- Providers organized by feature
- Clean dependency injection

### 🌍 **Internationalization**
- Support for 8 Indian languages
- Easy to add new languages
- Consistent localization structure

### 🎯 **Widget Organization**
- **UI Components**: Basic, reusable UI elements
- **Form Components**: Form-specific widgets
- **Layout Components**: Structural and layout widgets

### 🛠 **Utilities**
- Common constants and configurations
- Extensions for common operations
- Reusable helper functions

## Best Practices

1. **Import Organization**: Use relative imports for internal files
2. **Naming Conventions**: Follow Dart naming conventions
3. **File Structure**: Keep related files in the same directory
4. **Dependency Management**: Minimize cross-directory dependencies
5. **Code Reusability**: Extract common functionality into utilities

## Adding New Features

1. **Screens**: Add to appropriate feature directory under `screens/`
2. **Widgets**: Categorize and add to appropriate widget directory
3. **Services**: Add business logic to `services/`
4. **State**: Create providers in `state_management/providers/`
5. **Models**: Add data models to `models/`

This structure ensures maintainability, scalability, and easy navigation for developers working on the project.
