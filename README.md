# Habit Tracker

A Flutter mobile app for tracking daily habits — add habits, mark them complete, view weekly progress reports, and get reminder notifications. Built with local data persistence and Flutter.

## Features
- User authentication (login/registration)
- Add, complete, and manage daily habits
- Weekly progress reports
- Customizable notifications/reminders
- Local data persistence

## User Stories

### Login/Registration
- Account registration/login
- Error feedback upon entering incorrect username/password

### Profile
- Profile setup: Save personal details (name, username, age) during or after registration
- Profile display: Display the saved username in the app's header/home screen

### Home Page
- Welcome Message: Display a greeting with user's name 
- Habit List View: Display all pending habit on home screen.
- Completed Habit View: Display all completed habit on home screen bottom.

### Habits
- Add Habit:Create a new habit and assign a color to it for personalization
- Complete Habit: Mark a habit as done and move it to the completed list
- Delete Habit: Remove a habit from the list permanently

### Reports
- Weekly summary: Display the number of habits completed in the current week

### Notifications
- Enable reminders: Allow users to turn on notifications for a specific habit
- Set reminder time: Allow users to choose the date/time they receive a habit reminder

### Logout
- Sign out: Clear the session and return the user to the login screen