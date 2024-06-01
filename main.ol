include "console.iol"
include "/protocols/http.iol"
include "interfaces.iol"

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
    println@Console( "Welcome to the Collaborative Task Manager!" )()
    println@Console( "Do you have a user registered? (y: Yes, n: No): " )()
    in(answer)

    if (answer == "y") {
        println@Console( "Enter username:" )()
        in(username)

        // Check if the user is registered in the system
        checkUser@UserManager(username)(res)

        if (res.userRegistered == true) {
            println@Console( "Enter password:" )()
            in(password)
        } else {
            println@Console( "User not found. Registering a new user..." )()
            println@Console( "Enter username:" )()
            in(username)
            println@Console( "Enter password:" )()
            in(password)

            // User registration
            registerUser@UserManager(username)(res)
            println@Console( "User registered correctly!" )()
        }

    } else {
        println@Console( "Registering a new user..." )()
        println@Console( "Enter username:" )()
        in(username)
        println@Console( "Enter password:" )()
        in(password)

        // User registration
        registerUser@UserManager(username)()
        println@Console( "User registered correctly!" )()
    }

    // Menu
    println@Console( "####################################" )()
    println@Console( "Select an option:" )()
    println@Console( "1. Create a new task" )()
    println@Console( "2. Delete a task" )()
    println@Console( "3. List all tasks" )()
    println@Console( "4. List all tasks assigned to a user" )()
    println@Console( "5. Modify task user" )()
    println@Console( "6. Modify task status" )()
    println@Console( "7. Show notifications historial of a user" )()
    println@Console( "8. Exit" )()
    println@Console( "####################################" )()
    in(option)

    if (option == "1") {
        println@Console( "Enter task name:" )()
        in(req[0].taskName)
        println@Console( "Enter task description:" )()
        in(req[1].taskDescription)
        println@Console( "Enter task user:" )()
        in(req[2].taskUser)

        // Create a new task
        createTask@TaskManager(req)(res)
        println@Console( "Task created correctly!" )()

    } else if (option == "2") {
        println@Console( "Enter task name:" )()
        in(taskName)

        // Delete a task
        deleteTask@TaskManager(taskName)(res)
        println@Console( "Task deleted correctly!" )()

    } else if (option == "3") {
        // List all tasks
        listAllTasks@TaskManager()(res)
        println@Console( "Tasks:" )()
        println@Console( res.tasks )()

    } else if (option == "4") {
        println@Console( "Enter username:" )()
        in(username)

        // List all tasks assigned to a user
        listTasksByUser@TaskManager(username)(res)
        println@Console( "Tasks:" )()
        println@Console( res.tasks )()

    } else if (option == "5") {
        println@Console( "Enter task name:" )()
        in(req[0].taskName)
        println@Console( "Enter new task user:" )()
        in(req[1].taskUser)

        // Modify task user
        modifyTaskUser@TaskManager(req)(res)
        println@Console( "Task user modified correctly!" )()

    } else if (option == "6") {
        println@Console( "Enter task name:" )()
        in(req[0].taskName)
        println@Console( "Enter new task status:" )()
        in(req[1].taskStatus)

        // Modify task status
        modifyTaskStatus@TaskManager(req)(res)
        println@Console( "Task status modified correctly!" )()

    } else if (option == "7") {
        println@Console( "Enter username:" )()
        in(username)

        // Show notifications historial of a user
        showNotifications@NotificationManager(username)(res)
        println@Console( "Notifications:" )()
        println@Console( res.notifications )()

    } else if (option == "8") {
        println@Console( "Goodbye!" )()
        exit

    } else {
        println@Console( "Invalid option" )()
    }
}