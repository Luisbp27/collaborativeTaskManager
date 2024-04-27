include "console.iol"
include "/protocols/http.iol"

execution { concurrent }

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
    println@Console( "Welcome to the Collaborative Task Manager!" )();
    println@Console( "Registering a new user..." )();
    println@Console( "Enter username:" )();
    in(username);
    println@Console( "Enter password:" )();
    in(password);

    // User registration
    registerUser@UserManager(user)();

    // Simulate task creation
    taskResponse = createTask@TaskManager({title: "New Project Task", description: "Complete the integration of the Jolie system", dueDate: "2024-05-01", assignedTo: user.username})();

    // Notify user of the task creation
    sendNotification@NotificationManager({userId: username, message: "You have a new task assigned: " + taskResponse.message})();

    println@Console("Task created and notification sent.")();
}
