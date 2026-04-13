# Task Manager App (Flutter + Firebase)

## Overview
This is a task management mobile app built using Flutter and Firebase Firestore. The app allows users to create, read, update, and delete tasks in real time. Each task can also contain nested subtasks, making it easier to organize smaller steps within a larger task.

The app uses Firestore’s real-time database, so any changes made (adding, deleting, or updating tasks) are instantly reflected in the UI without needing to refresh.

---

## Features
- Add new tasks
- Mark tasks as complete (checkbox)
- Delete tasks
- Real-time updates using Firebase Firestore
- Expandable tasks with nested subtasks

---

## Enhanced Features

### 1. Nested Subtasks System
Each task can be expanded to reveal a list of subtasks. Users can:
- Add subtasks dynamically
- View subtasks under each task
- Organize complex tasks into smaller steps

This improves usability by allowing users to break down larger tasks into manageable pieces.

---

### 2. Subtask Completion with Checkboxes
Each subtask includes its own checkbox:
- Users can mark subtasks as complete
- Completed subtasks show a line-through effect
- Changes are saved in Firestore in real time

This enhances the app by providing more detailed progress tracking within each task.

---

## Technologies Used
- Flutter (UI framework)
- Dart (programming language)
- Firebase Firestore (cloud database)
- StreamBuilder (real-time UI updates)

---

## Setup Instructions

1. Clone the repository