# Security System

This repository contains the ***Security System*** project developed in the Digital Laboratory II course at the **University of São Paulo**. This project was made in 2021 during the COVID-19 pandemic and would not have been possible without the effort of the teaching staff.

The lab sessions were carried out using an innovative RemoteLab that allowed students to load VHDL code into the DE0-CV baseboard remotely and perform tests using the MQTT messaging protocol. To learn more about this fascinating iniciative, please check out this [paper](https://www.researchgate.net/publication/355943442_Dashboard_IoT_Remote_Lab_with_MQTT_Protocol).

After a series of experiments, this project was developed in the final 3 weeks on the course with the goal of allowing the students to give their own personal spin on the course material. For us, it was an opportunity to expand on what we had seen and try to present something completely fresh.

# Table of Contents
1. [Physical Requirements](#physical-requirements)
2. [System Requirements](#system-requirements)
3. [Project Documentation and Demo](#project-documentation-and-demo)
4. [Acknowledgements](#acknowledgements)

## Physical Requirements

This project was built using both the physical infrastructure of the University lab as well as some extra hardware we used at home (loving nicknamed the **Home Kit**). The project requires a ***SG90 servo motor*** and the ***HC-SR04 sensor***, in addition to the ***Wemos D1 R1 board*** which has the ***ESP8266*** component.

The password functionality was implemented using Arduino, so it is exclusive to the Home Kit. To enable demonstrations in the University Lab infrastructure, it is possible to deactivate the password functionality with an input signal. In this test mode, interaction with Arduino is not necessary. The Processing Dashboard and the Jupyter Notebook operate in this test mode.

To mediate communication with the laboratory's FPGA, it is also possible to use the ***MQTT Dash*** application.

## System requirements

The system offers easily configurable security options for the user, including:

- **At Home Mode:** When in at home mode, the HC-SR04 component can detect movement at the door, signaling the resident through MQTT and LEDs. The resident can then take appropriate action.
  
- **Away from Home Mode:** In away from home mode, any approach or movement is considered unwanted, triggering a buzzer to alert the neighborhood. The resident is also signaled through communication with their mobile device.

Additional features include the use of passwords to arm and disarm the security system, as well as logs corresponding to each sensor trigger written to a RAM for the resident to monitor the operating history of the system.

![Pseudocode algorithm](week1_algorithm.png)

## Project Documentation and Demo

This repository includes the complete [project documentation](Documentation.pdf). In contains details on the sprints, diagrams and explanations for the code.

If you're curious to see the project in action, we also prepared a video demonstration [available on Youtube](https://www.youtube.com/watch?v=LZQfi0l7xRA0). 

## Acknowledgements

We would like to express our gratitude to our professor **Edson Midorikawa** and classmates for their support in this project. Long live VHDL!!