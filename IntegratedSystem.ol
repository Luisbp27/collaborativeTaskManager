include "console.iol"
include "/protocols/http.iol"

outputPort UserManager {
    location: "socket://localhost:1235"
    protocol: http
    interfaces: UserManagementInterface
}

outputPort TaskManager {
    location: "socket://localhost:1234"
    protocol: http
    interfaces: TaskServiceInterface
}

outputPort NotificationManager {
    location: "socket://localhost:1236"
    protocol: http
    interfaces: NotificationInterface
}

main {
    Console.readLine@println("Welcome to the Collaborative Task Manager!")()
    Console.readLine@println("Registering a new user...")()
    Console.readLine@println("Enter username:")()
    var username = Console.readLine@readLine()()
    Console.readLine@println("Enter password:")()
    var password = Console.readLine@readLine()()

    // Simulate user registration
    UserManager.registerUser@({username: username, password: password, email: "user@example.com"})()
    Console.readLine@println("User registered. Creating a task...")()

    // Simulate task creation
    var taskResponse = TaskManager.createTask@({title: "New Project Task", description: "Complete the integration of the Jolie system", dueDate: "2024-05-01", assignedTo: username})()

    // Notify user of the task creation
    NotificationManager.sendNotification@({userId: username, message: "You have a new task assigned: " + taskResponse.message})()

    Console.readLine@println("Task created and notification sent.")()
}
