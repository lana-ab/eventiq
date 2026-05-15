# EventIQ — Event & Store Management App

A modern, cross-platform mobile application built using **Flutter** and powered by a RESTful backend. This repository highlights the clean architectural patterns, state management, and code organization used in the development process.

 Tech Stack & Architecture
* **Framework:** Flutter & Dart
* **Architecture / Pattern:** MVC (Model-View-Controller)
* **State Management:** GetX (Reactive Programming)
* **Networking:** HTTP Client with Bearer Token Authorization
* **Local Storage:** Shared Preferences for session tracking

 
Project Structure (Core)
The codebase strictly follows standard clean organization:
* `lib/view/`: UI Screens and custom layout components.
* `lib/logic/controllers/`: Business logic, reactive state handling, and API events.
* `lib/model/`: Strongly-typed data models and JSON Parsing factory constructors.
* `lib/services/`: Network service providers for centralizing API requests.
* `lib/routes/`: Centralized application routing management.


