# Brainify Frontend

## Table of Contents

- [Prerequisites](#prerequisites)
- [Downloading the Project](#downloading-the-project)
- [Installing Flutter and Dart](#installing-flutter-and-dart)
- [Setting Running Port](#setting-running-port)
- [Running the Project](#running-the-project)

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- Git
- IntelliJ IDEA (or any other preferred IDE)

## Downloading the Project

To download the project from GitHub, follow these steps:

1. Open your terminal or command prompt in preferred directory.
2. Clone the repository using the following command:

   ```sh
   git clone https://github.com/paulb2295/brainify_flutter.git
   ```
3. Navigate to the project directory:

   ```sh
   cd brainify_flutter
   ```
## Installing Flutter and Dart
1. Install Flutter
- Go to the Flutter website and follow the installation instructions for your operating system.
- After installing Flutter, add it to your system path.
2. Install Dart:
- Dart is included with Flutter, so there's no need to install it separately. Ensure that 
- Flutter and Dart are correctly installed by running:
   ```sh
   flutter --version
   ```
## Setting Running Port

1. To set the running port for the project to 55000 in IntelliJ:

2. Open IntelliJ IDEA and load the brainify_flutter project.

3. Go to Run > Edit Configurations.

4. Select your Flutter configuration.

In the Additional run args field, add the following:
   ```sh
   --web-port=55000
   ```
5. Click `Apply` and then `OK`.

## Running the Project

To prepare and run the project using IntelliJ:

1. Start Brainify Backend (clone link: https://github.com/paulb2295/brainify.git)
2. Open IntelliJ IDEA and load the brainify_flutter project.

3. Ensure all dependencies are installed by running:
   ```sh
   flutter pub get
   ```
4. To run the project, click on the Run button or use the terminal command:
   ```sh
   flutter run -d chrome --web-port=55000
   ```
or Right-click on the `main.dart` file and select `Run 'main.dart'`.


