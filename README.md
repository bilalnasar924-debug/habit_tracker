# Habit Tracker

A Flutter mobile app for tracking daily habits — add habits, mark them complete, view weekly progress reports, get reminder notifications, and stay motivated with a daily quote. Built with Flutter, Firebase, and local data persistence.

## Features
- User authentication (login/registration)
- Add, complete, and manage daily habits
- Weekly progress reports
- Customizable notifications/reminders
- Local data persistence (Firestore)
- External API integration (daily motivational quote)
- Personal settings (profile, age, country)

## User Stories

1. **Login/Registration**
   Account registration/login with error feedback upon entering incorrect credentials

2. **Home Page**
   Display a welcome message with the user's name and a list of pending habits on the home screen

3. **Habits**
   Add a new habit and assign it a color for personalization; mark a habit as done or delete it permanently

4. **Reports**
   Display a weekly summary of the number of habits completed in the current week

5. **Settings**
   Allow the user to view and update personal details (username, age, country)

6. **Notifications**
   Allow the user to enable reminders for specific habits and choose the time they receive them

7. **External API**
   Display a daily motivational quote fetched from an external API on the home screen

8. **Profile**
   Display the saved username in the app's header/home screen after login

9. **Logout**
   Clear the session and return the user to the login screen