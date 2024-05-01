include "console.iol"
include "/protocols/http.iol"

execution: concurrent

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
    println@Console( "Do you have a user registered? (y: Yes, n: No): " )();
    in(answer);

    if (answer == "y") {
        println@Console( "Enter username:" )();
        in(username);

        // Check if the user is registered in the system
        checkUser@UserManager(username)(res)

        if (res.userRegistered == true) {
            println@Console( "Enter password:" )();
            in(password);
        } else {
            println@Console( "User not found. Registering a new user..." )();
            println@Console( "Enter username:" )();
            in(username);
            println@Console( "Enter password:" )();
            in(password);

            // User registration
            registerUser@UserManager(user)();
            println@Console( "User registered correctly!" )();
        }

    } else {
        println@Console( "Registering a new user..." )()
        println@Console( "Enter username:" )()
        in(username)
        println@Console( "Enter password:" )()
        in(password)

        // User registration
        registerUser@UserManager(user)();
        println@Console( "User registered correctly!" )();
    }

    // Menu
    println@Console( "####################################" )();
    println@Console( "Select an option:" )();
    println@Console( "1. Create a new task" )();
    println@Console( "2. Delete a task" )();
    println@Console( "3. List all tasks" )();
    println@Console( "4. List all tasks assigned to a user" )();
    println@Console( "5. Modify task user" )();
    println@Console( "6. Modify task status" )();
    println@Console( "7. Modify user notification preference" )();
    println@Console( "8. Show notifications historial of a user" )();
    println@Console( "9. Exit" )();
    println@Console( "####################################" )();
    in(option);

    switch (option) {
        case "1" {
            createTask();
        }
        case "2" {
            listAllTasks();
        }
        case "3" {
            listTasksByUser();
        }
        case "4" {
            modifyTaskStatus();
        }
        case "5" {
            modifyNotificationPreference();
        }
        case "6" {
            println@Console( "Goodbye!" )();
            [ shutdown()() ]{
                exit
            }
        }
    }
}
