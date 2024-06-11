# Collaborative Task Manager

## Service Oriented Software Engineering - Università di Bologna

### Author: Lluis Barca Pons

This is a project developed for the course of Service-Oriented Software Systems at the University of Bologna.

## Introduction

- **Project Overview**: The Collaborative Task Management System is a distributed
application designed to facilitate efficient task creation, assignment, and tracking among users. The system will be implemented using the Jolie programming language, leveraging its microservices architecture to ensure scalability and modularity.

- **Objectives**: The primary objectives of the project include:
  - Create a user-friendly interface for task management.
  - Implement microservices for task creation, assignment, status tracking, and notifications.
  - Enable concurrent processing to handle multiple users and tasks simultaneously.
  - Ensure secure communication and data storage.

## System Architecture

- **Microservices**: The system will consist of the following microservices:
  - User Management Service: Responsible for user registration, authentication, and profile management.
  - Task Service: Manages the creation, assignment, and status tracking of tasks.
  - Notification Service: Sends real-time notifications for task updates to users.
  - Concurrent Processing Service: Handles concurrent user interactions and task updates.
- **Communication**: Communication between microservices will be implemented using Jolie's built-in communication primitives. The services will interact through well-defined interfaces, ensuring seamless integration.

## Functional Requirements

- **User Registration and Authentication**
  - Users can register with the system, providing necessary details.
  - Secure user authentication mechanism.
  - User profile management for updating personal information.

- **Task Management**
  - Users can create tasks, specifying details such as title, description, and due date.
  - Tasks can be assigned to other registered users.
  - Real-time status updates for tasks (e.g., in progress, completed).
  - Users can view and filter tasks based on various criteria.

- **Notifications**
  - Real-time notifications for task updates.
  - Notification preferences for users (e.g., email, in-app notifications).

- **Concurrent Processing**
  - Concurrent handling of user interactions and task updates.
  - Efficient resource utilization to handle multiple users simultaneously.

##  Non-functional Requirements

- **Security**
  - Implement encryption for communication between microservices.
  - Secure storage of user data and task information.

- **Scalability**
  - Design microservices to scale horizontally to handle an increasing number of users and tasks.

- **User Interface**
  - Intuitive and responsive user interface for task management.
  - Compatibility with common web browsers.

## BPMN diagrams of main processes

- User Registration Process
- Task Creation and Assignment Process
- Task Tracking Process
- Notification Process

## Todo List

- [ ] Notification Service
  - [x] sendNotification()
  - [ ] notificationsHistorialByUser()
- [ ] Task Service
  - [x] createTask()
  - [ ] assignTask()
  - [ ] updateTaskStatus()
  - [x] deleteTask()
  - [x] listAllTasks()
  - [x] listTasksByUser()
- [ ] User Management Service
  - [x] registerUser()
  - [ ] authUser()
  - [x] deleteUser()
