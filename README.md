# 🚀 Project Name

## 📌 Table of Contents
- [Introduction](#introduction)
- [Demo](#demo)
- [Inspiration](#inspiration)
- [What It Does](#what-it-does)
- [How We Built It](#how-we-built-it)
- [Challenges We Faced](#challenges-we-faced)
- [How to Run](#how-to-run)
- [Tech Stack](#tech-stack)
- [Team](#team)

---

## 🎯 Introduction
A brief overview of your project and its purpose. Mention which problem statement are your attempting to solve.
https://github.com/ewfx/gaied-gen-explorers/blob/main/artifacts/WF_Gemini_Email_Cat.pptx


## 🎥 Demo
📹 [Video Demo](link-to-image) 
🖼️ Screenshots:

![Screenshot 1](link-to-image)

https://github.com/user-attachments/assets/ec2b8f7f-8f28-4fcf-932d-03977b2a9e3c

💡 Inspiration

Commercial Bank Lending Service teams receive a significant volume of servicing requests through emails. These emails contain diverse requests, often with attachments, which must be processed efficiently. Currently, a manual triage process is used where gatekeepers read, interpret, classify, and route these requests. This process is time-consuming, error-prone, and inefficient at scale.

The challenge is to automate email classification and data extraction using Generative AI (LLMs) to improve efficiency, accuracy, and turnaround time while minimizing gatekeeping activities. Our Flutter desktop app provides a solution by leveraging AI to classify emails, extract relevant data, and facilitate skill-based routing of service requests.

⚙️ What It Does

Parses .EML email files from a local folder.

Extracts key email attributes: Date, From, Subject, and Body.

Uses OpenAI API to classify emails into Request Type and Sub Request Type.

Provides confidence scores for classification accuracy.

Detects duplicate emails to prevent redundant service requests.

Displays extracted emails in a structured table format.

Enables bulk processing of multiple emails at once.

🛠️ How We Built It
![image](https://github.com/user-attachments/assets/b4b5ae0a-9539-40c4-869b-a90748227387)


Frontend: macOS/Flutter (Desktop App)

Email Parsing: Dart eml package (reads .EML files)

AI Classification: gemini

File Selection: File picker pod

Networking: http package for API calls

🚧 Challenges We Faced

Handling rate limits from OpenAI API and Gemini (Solution: Implemented retries & error handling).

Ensuring valid JSON output from AI responses (Solution: Prompt engineering & structured parsing).

Extracting structured data from email bodies & attachments (Solution: Priority-based extraction rules).

Managing duplicate email detection efficiently.

🏃 How to Run

Clone the repository

https://github.com/ewfx/gaied-gen-explorers.git

Navigate to the project directory

Install dependencies

Run the application as Desktop app

🏰 Tech Stack

🔹 Frontend: SwifUI (Desktop App)

🔹 Email Parsing: EML Parser

🔹 AI Classification: Gemini API

🔹 Networking: HTTP Package

🔹 File Handling: File Picker Plugin

This Desktop app automates email triage and classification, reducing manual workload and improving processing efficiency. 🚀
## 👥 Team
- **Sudhanshu Kumar** - [GitHub](#) | [LinkedIn](#)
- **Neha Vishnoi** - [GitHub](#) | [LinkedIn](#)
- **Basavaraj T** - [GitHub](#) | [LinkedIn](#)
- **Avinash Shyam** - [GitHub](#) | [LinkedIn](#)
