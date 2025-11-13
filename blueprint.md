# Project Blueprint

## Overview

This project is a Flutter-based expense tracker application. It allows users to track their expenses, view a summary of their spending, and see a list of recent transactions. The application is designed with a clean and modern user interface, following Material Design principles. It also integrates with native Android code to fetch expense data.

## Style, Design, and Features

### Implemented

*   **Modern UI:** The app uses the Material 3 design system with a custom color scheme and typography from Google Fonts (`Lato` and `Oswald`).
*   **Expense Summary:** A summary card on the home screen displays:
    *   Total expenses.
    *   Number of expenses below a certain threshold.
    *   Number of expenses above a certain threshold.
*   **Transaction List:** A list of recent transactions is displayed on the home screen, showing the title, date, and amount of each expense.
*   **Native Integration:** The app uses a `MethodChannel` to communicate with native Android code to fetch expense data.
*   **Git Version Control:** The project is connected to a remote GitHub repository for version control.

## Current Task: Initial Setup and GitHub Integration

### Plan and Steps

1.  **Initialize Git:**
    *   Initialized a local Git repository.
    *   Created an initial commit with all project files.
2.  **Connect to GitHub:**
    *   Attempted to connect to the remote repository provided by the user.
    *   Encountered and resolved several common Git issues:
        *   Incorrect remote URL.
        *   Mismatched branch names (`master` vs. `main`).
        *   Remote repository having changes not present locally.
    *   Successfully pushed the local `master` branch to the remote `main` branch using a force push to overwrite the remote repository.
3.  **Create Project Blueprint:**
    *   Create this `blueprint.md` file to document the project's features and the development process.
