# Collaborative Task Manager

## Service Oriented Software Engineering - University of Bologna

### Tutors: Prof. Ivan Lanese, Prof. Davide Rossi

#### Author: Lluis Barca Pons

#### Course year: 2023/2024

This is a project developed for the course of Service-Oriented Software Systems at the University of Bologna. Everything included in this repository is for **academic purposes only**.

## Abstract

- **Project Overview**: The Collaborative Task Management System is a distributed
application designed to facilitate efficient task creation, assignment, and tracking among users. The system will be implemented using the Jolie programming language, leveraging its microservices architecture to ensure scalability and modularity.

- **Objectives**: The primary objectives of the project include:
  - Create a user-friendly interface for task management.
  - Implement microservices for task creation, assignment, status tracking, and notifications.
  - Enable concurrent processing to handle multiple users and tasks simultaneously.
  - Ensure secure communication and data storage.

## How to run the project

First you have to install Jolie on your machine. You can download it from the [official website](https://www.jolie-lang.org/downloads.html).

Once you have installed Jolie, you have to be sure that the `jolie` command is added to your PATH. You can check it by running `jolie --version` in your terminal.

After that, you can run the project by executing the following commands in the root directory of the project. You should execute each service in different terminals:

```bash
# Terminal 1
jolie UserManagaementService.ol
```

```bash
# Terminal 2
jolie TaskManager.ol
```

```bash
# Terminal 3
jolie TaskService.ol
```

```bash
# Terminal 4
jolie Main.ol
```

In `Terminal 4` you could interact with the application.

## Collaboration to Jolie Repository

During the development of this project I stayed in contact with the Jolie Community via Discord and I did some [contributions](https://github.com/Luisbp27/docs) to the documentation of the language.

## Todo List

- [x] Notification Service
  - [x] sendNotification()
  - [x] notificationsHistorialByUser()
- [x] Task Service
  - [x] createTask()
  - [x] modifyTaskUser()
  - [x] modifyTaskStatus()
  - [x] deleteTask()
  - [x] listAllTasks()
  - [x] listTasksByUser()
- [x] User Management Service
  - [x] registerUser()
  - [x] authUser()
  - [x] checkUser()
  - [x] deleteUser()
