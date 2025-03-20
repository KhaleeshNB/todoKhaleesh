# Todo App with Flutter and Provider

A Todo app built using Flutter, Provider for state management, and Firebase Firestore for data storage. This app allows users to create, edit, delete, and complete tasks with real-time updates. It also supports sharing tasks via the `share_plus` package.

## Features

- **Todo App with Provider**: The app uses the **Provider** package for state management, allowing efficient and reactive updates across the UI.
- **Use of ProxyProvider**: A `ProxyProvider` is used to inject dependencies into the app, allowing different components to access shared data in a clean and organized manner.

- **Provider Extension Method**: Extension methods are used to extend the functionality of the `Provider` and simplify the access to shared data and services throughout the app.

- **Create Task**: Click on the "What to do?" field, type the task description, and submit it to add a new task to the list. Tasks are stored in Firebase Firestore.

- **Remove Task**: Slide the task tile using a **Dismissible** widget to remove a task from the list. This triggers an action to delete the task both locally and from Firebase Firestore.

- **Complete Task**: Tap the checkbox next to each task to mark it as completed. The state of the checkbox will be reflected in the UI and saved in Firebase.

- **Edit Task**: Tap on any task to edit its description. Once edited, the changes are updated in both the local state and Firebase Firestore.

- **Real-time Updates with Streams**: The app uses **Firestore Streams** to listen to changes in the database and update the UI in real-time. Whenever a task is added, edited, or removed, the UI is updated automatically without needing to refresh.

- **Firebase and Firestore Integration**: The app is integrated with Firebase and Firestore for cloud-based storage of tasks. It leverages Firestore's real-time database capabilities for seamless data syncing across multiple devices.

- **Task Sharing**: Each task has a share button to share the task's details with others using the **share_plus** package.

- **MVVM Architecture**: The app follows the **Model-View-ViewModel (MVVM)** design pattern, separating the UI (View), business logic (ViewModel), and data (Model) into distinct layers. This approach makes the app easier to maintain and test.
