```markdown

# 📝 Notes App

A Flutter-powered mobile application for creating, editing, and organizing personal notes. Built as part of a test assessment, this app showcases state management, Firestore integration, and rich-text editing with Flutter Quill.

---

## 🚀 Features

- 🔐 **Firebase Auth**: Secure user sign-in and registration
- 📄 **Rich-text Notes**: Create and edit notes using [Flutter Quill](https://pub.dev/packages/flutter_quill)
- 📂 **Tags & Categories**: Organize notes using custom tags
- 📌 **Pin Notes**: Prioritize important notes by pinning them
- 🗑️ **Soft Delete**: Deleted notes are moved to trash for safety
- 🧠 **Search & Filter**: Search notes by title, content, tag, or creation date
- 🌙 **Dark/Light Mode**: Toggle between system, dark, or light themes
- 📤 **Share & Export**: Export notes to PDF and share them
- 🟢 **Realtime Updates**: Notes sync instantly via Firebase Firestore
- 📱 **Responsive UI**: Smooth UI experience across screen sizes using `flutter_screenutil`

---

## 🧪 Tech Stack

- **Flutter** (Frontend)
- **Firebase** (Backend: Auth, Firestore, Storage)
- **flutter_quill** (Rich-text Editor)
- **Stack** (ViewModel & Dependency Injection)
- **GetIt** (Service Locator)
- **ScreenUtil** (Responsive Design)

---

## 📸 Screenshots

| Home | Create Note | Rich Editor |
|------|-------------|-------------|
| ![](assets/screenshots/home.png) | ![](assets/screenshots/create_note.png) | ![](assets/screenshots/editor.png) |

---

## 📁 Project Structure

```

lib/
├── utils/              # utilities and services
├── model/              # Data models
├── view/view_model     # Screens & UI widgets State management (Stack ViewModels)
├── utils/              # Theme, constants, helpers
├── services/           # Firebase and shared logic
└── main.dart           # Entry point

````

---

## 🛠️ Setup & Run

1. **Clone the repo:**

   ```bash
   git clone https://github.com/Heebu/test_assessment.git
   cd notes-app
````

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**

    * Create a Firebase project
    * Enable Auth (email/password)
    * Add Firestore database
    * Download `google-services.json` & `GoogleService-Info.plist` into respective platform folders

4. **Run the app:**

   ```bash
   flutter run
   ```

---

## ✅ To-Do & Future Improvements

* [ ] Add biometric authentication
* [ ] Add image support to notes
* [ ] Support offline storage with sync
* [ ] Enable note collaboration

---

## 🧑‍💻 Author

**Idris Adedeji**
Flutter Developer | Fullstack in Progress
• [GitHub](https://github.com/Heebu) • [LinkedIn](https://www.linkedin.com/in/idris-adedeji-1b3162246/)

---

## 📄 License

This project is for educational/demo purposes. You may modify and reuse with credit.

