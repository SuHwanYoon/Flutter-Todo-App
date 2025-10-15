# Flutter Todo App

A simple and intuitive To-Do list application built with Flutter. This project serves as a portfolio piece to showcase mobile app development skills using modern technologies.

## 🚀 Features

- **User Authentication**: Secure sign-in and registration functionality.
- **Task Management**: Create, read, update, and delete tasks.
- **State Management**: Efficiently manages app state using Flutter Riverpod.
- **Responsive UI**: Adapts to different screen sizes for a seamless experience on any device.
- **Custom UI Components**: Built with reusable and customized widgets for a consistent look and feel.

## 📸 Screenshots

Here are some screenshots of the user authentication interface:

| Login Screen 1 | Login Screen 2 | Login Screen 3 |
| :---: | :---: | :---: |
| <img src="screenShots/login_widget1.png" width="250"> | <img src="screenShots/login_widget2.png" width="250"> | <img src="screenShots/login_widget3.png" width="250"> |

| Login Screen 4 | Register Screen 1 |
| :---: | :---: |
| <img src="screenShots/login_widget4.png" width="250"> | <img src="screenShots/register_wiget1.png" width="250"> |

| Login Screen with Error Message | Login with No Account Message |
| :---: | :---: |
| <img src="screenShots/login_empty_error_message1.png" width="250"> | <img src="screenShots/login_no_account_message1.png" width="250"> |

| Register Success |
| :---: |
| <img src="screenShots/register_success1.png" width="500"> |

### Tapbar & NavigationBar

| Home Screen | Account Screen |
| :---: | :---: |
| <img src="screenShots/home_screen_wiget.png" width="250"> | <img src="screenShots/account_screen_wiget.png" width="250"> |


### Account Screen & Sign Out

The account screen displays the user's email and provides a sign-out option. Tapping the 'Sign Out' button shows a confirmation dialog. Upon confirmation, the user is logged out and redirected to the sign-in screen.

| Account Screen | Sign Out Confirmation | Back to Sign In Screen |
|:---:|:---:|:---:|
| <img src="screenShots/account_screen1.png" width="250"> | <img src="screenShots/account_screen2.png" width="250"> | <img src="screenShots/account_screen3.png" width="250"> |

### Add Task Screen

| Add Task 1 | Add Task 2 | Add Task 3 |
| :---: | :---: | :---: |
| <img src="screenShots/add_screen_wiget1.png" width="250"> | <img src="screenShots/add_screen_wiget2.png" width="250"> | <img src="screenShots/add_screen_wiget3.png" width="250"> |

### Add Task to Firestore

The user can create a task, which is then saved to Firestore.

| Add Task to Firestore 1 |
| :---: |
| <img src="screenShots/add_task_firestore1.png" width="500"> |

| Add Task to Firestore 2 |
| :---: |
| <img src="screenShots/add_task_firestore2.png" width="500"> |

### Home Screen (All Tasks)

The home screen displays a list of all the tasks that have been added.

| All Task Screen |
| :---: |
| <img src="screenShots/all_task_screen1.png" width="250"> |

### Task Checkbox State Change

| False | False |
|:---:|:---:|
| <img src="screenShots/checkbox_false1.png" width="250"> | <img src="screenShots/checkbox_false2.png" width="250"> |

| True | True |
|:---:|:---:|
| <img src="screenShots/checkbox_true1.png" width="250"> | <img src="screenShots/checkbox_true2.png" width="250"> |

### Update Task

| Update Task 1 | Update Task 2 | Update Task 3 |
|:---:|:---:|:---:|
| <img src="screenShots/update_task1.png" width="250"> | <img src="screenShots/update_task2.png" width="250"> | <img src="screenShots/update_task3.png" width="250"> |

### Delete Task

| Delete Task 1 | Delete Task 2 | Delete Task 3 |
|:---:|:---:|:---:|
| <img src="screenShots/delete_task1.png" width="250"> | <img src="screenShots/delete_task2.png" width="250"> | <img src="screenShots/delete_task3.png" width="250"> |

### Complete and Incomplete Task Screens

When a task is checked, it appears on the 'Complete' screen. If it's unchecked, it moves back to the 'Incomplete' screen.

| ALL Task | InCompleted Task | Complete Task |
|:---:|:---:|:---:|
| <img src="screenShots/incom_com_task1.png" width="250"> | <img src="screenShots/incom_com_task2.png" width="250"> | <img src="screenShots/incom_com_task3.png" width="250"> |


### Priority Selection

For a better user experience, when adding a task, you can set a priority (Low, Medium, High). Each priority is represented by a different color. This color-coding is also reflected on the main task list, making it easy to identify task priorities at a glance.

| Priority Low | Priority Medium | Priority High | All Tasks Screen |
|:---:|:---:|:---:|:---:|
| <img src="screenShots/priority_selection1.png" width="250"> | <img src="screenShots/priority_selection2.png" width="250"> | <img src="screenShots/priority_selection3.png" width="250"> | <img src="screenShots/priority_selection4.png" width="250"> |


## 🛠️ Technologies Used

- **Frontend**: [Flutter](https://flutter.dev/)
- **Programming Language**: [Dart](https://dart.dev/)
- **State Management**: [Flutter Riverpod](https://riverpod.dev/)
- **Backend & Authentication**: Firebase (inferred from project structure)
- **Routing**: [GoRouter](https://pub.dev/packages/go_router) (inferred from file structure)