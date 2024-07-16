# Currency Converter (Linux/Android)

## Overview

The Currency Converter is a robust application designed to provide real-time currency conversion. The project comprises two main components: the server-side application built with Java and SpringBoot, and the client-side application developed using C++ and Qt5.15, ensuring cross-platform compatibility with Linux and Android.

## Features

- **Real-time currency conversion** based on the latest exchange rates from the Central Bank.
- **Cross-platform support**, functioning seamlessly on both Linux and Android devices.
- **User-friendly interface** for quick and easy conversion.
- **Offline mode** to access previously fetched exchange rates without an internet connection.
- **Favorites** feature to save frequently used currency pairs.
- **Graphical representation** of currency rate trends over a specified period.
- **Customizable settings** including language and theme options.

## Server-Side

### Technologies Used

- **Java**
- **SpringBoot**
- **RESTful API**
- **Central Bank API for currency rates**

### Functionality

- Accepts requests from the client application.
- Fetches real-time currency data from the Central Bank API.
- Processes and formats the data for client use.
- Ensures secure and efficient data handling.

## Client-Side

### Technologies Used

- **C++**
- **Qt5.15**
- **QML**
- **Cross-platform build support**

### Functionality

- Provides a graphical user interface for currency conversion.
- Allows users to select base and target currencies.
- Displays conversion results instantly.
- Stores favorite conversions for quick access.
- Displays historical currency trends.
- Offers customizable UI settings.
