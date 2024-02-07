# Processing interface for the Security System

## Introduction
The **QuietWatch** project, developed as part of the Digital Laboratory II course, aims to create a security system with various features including password protection, persistence of data, and audio feedback using the Processing environment. In this document, we'll provid an overview of the code for the user interface made with Processing, including required libraries, and the logic behind the system.

## Required Libraries
The following libraries are required to run the **QuietWatch** project:
- Java libraries:
  - `java.io.IOException`
  - `java.time.format.DateTimeFormatter`
  - `java.time.LocalDateTime`
- Processing libraries:
  - `mqtt.*`: for MQTT communication
  - `ddf.minim.*`: for audio playback

## Logic Overview
- The system interacts with the interface using keyboard commands (PUBLISH):
  - `l`: toggle ligar (turn on)
  - `r`: toggle reset
  - `m`: toggle mode
  - `x`, `y`: control sel_mux[0], sel_mux[1] respectively.

## Code Overview
The code structure consists of the following key components:
1. **Setup**: Executed once during the initialization of the program. It includes initialization of MQTT connection, Minim library setup for audio, and initializing various variables.
2. **Draw**: Executed continuously to render the graphical user interface. It includes functions to draw the control panel and widgets for inputs and outputs.
3. **KeyPressed**: Processes keyboard inputs and toggles states accordingly.
4. **MQTT Functions**: Includes functions related to MQTT communication such as `clientConnected()`, `messageReceived()`, and `connectionLost()`.

## Usage
- To interact with the system, use the following keyboard commands:
  - `l`: toggle ligar
  - `r`: toggle reset
  - `m`: toggle mode
  - `x`, `y`: control sel_mux[0], sel_mux[1] respectively.
