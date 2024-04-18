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

main {
    // User Interface logic to interact with user and task services
    Console.readLine@println("Enter username:")()
    var username = Console.readLine@readLine()()
    Console.readLine@println("Enter password:")()
    var password = Console.readLine@readLine()()

    // Simulate user registration
    UserManager.registerUser@({username: username, password: password, email: ""})()
    Console.readLine@println("User registered. Creating a task...")()

    // Simulate task creation
    TaskManager.createTask@({title: "New Task", description: "Complete Jolie project", dueDate: "2024-04-20", assignedTo: username})()
    Console.readLine@println("Task created and assigned.")()
}
