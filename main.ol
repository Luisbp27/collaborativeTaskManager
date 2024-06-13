include "/protocols/http.iol"
include "/interfaces/interfaces.iol"
include "interfaces/objects.iol"
include "console.iol"

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

init {
    println@Console( "Welcome to the Collaborative Task Manager!" )();
    println@Console( "Do you have a user registered? (y: Yes, n: No): " )();
    readLine@Console()(answer);

    if (answer == "y") {
        println@Console( "Enter your ID:" )();
        readLine@Console()(req.id);
        req.id = int(req.id);
        println@Console( "Enter username:" )();
        readLine@Console()(req.name);
        println@Console( "Enter password:" )();
        readLine@Console()(req.password);

        // Check if the user is registered in the system
        authUser@UserManager(req)(res);

        if (res.userRegistered == false) {
            println@Console( "\nUser not found. Registering a new user..." )();
            println@Console( "Enter username:" )();
            readLine@Console()(req.name);
            println@Console( "Enter password:" )();
            readLine@Console()(req.password);
            println@Console( "Enter email:" )();
            readLine@Console()(req.email);

            // User registration
            registerUser@UserManager(req)(res);
            println@Console( "User registered correctly, your ID is: " + res.id )()
        }

    } else if (answer == "n") {
        println@Console( "Registering a new user..." )();
        println@Console( "Enter username:" )();
        readLine@Console()(reqNew.name);
        println@Console( "Enter password:" )();
        readLine@Console()(reqNew.password);
        println@Console( "Enter email:" )();
        readLine@Console()(reqNew.email);

        // User registration
        registerUser@UserManager(reqNew)(resNew);
        println@Console( "User registered correctly, your ID is: " + resNew.id )()

    } else {
        println@Console( "Invalid option" )()
        exit
    }

    println@Console( "Welcome!" )()
}

main {

    option = "0";
    while (option != "8") {
        // Menu
        println@Console( "\n####################################" )();
        println@Console( "Select an option:" )();
        println@Console( "1. Create a new task" )();
        println@Console( "2. Delete a task" )();
        println@Console( "3. List all tasks" )();
        println@Console( "4. List all tasks assigned to a user" )();
        println@Console( "5. Modify task user" )();
        println@Console( "6. Modify task status" )();
        println@Console( "7. Show notifications historial of a user" )();
        println@Console( "8. Exit" )();
        println@Console( "####################################\n" )();
        readLine@Console()(option);

        if (option == "1") {
            println@Console( "Enter your ID:" )();
            readLine@Console()(req1.userId);
            req1.userId = int(req1.userId);
            println@Console( "Enter task title:" )();
            readLine@Console()(req1.title);
            println@Console( "Enter task description:" )();
            readLine@Console()(req1.description);
            println@Console( "Enter today date (format: DD/MM/YYYY):" )();
            readLine@Console()(req1.date);
            println@Console( "Enter who the task is assigned to:" )();
            readLine@Console()(req1.assignedTo);

            // Create a new task
            createTask@TaskManager(req1)
            println@Console( "Task created correctly!" )()

        } else if (option == "2") {
            println@Console( "Enter Task title:" )();
            readLine@Console()(req2.title);

            // Delete a task
            deleteTask@TaskManager(req2)

        } else if (option == "3") {
            // List all tasks
            listAllTasks@TaskManager()(res3)
            println@Console( "\nID | Title | Description | Date | Assigned to | Status" )();
            println@Console( "--------------------------------------------------------" )();
            println@Console( res3 )()

        } else if (option == "4") {
            println@Console( "Enter User ID:" )();
            readLine@Console()(req4.userId);
            req4.userId = int(req4.userId);

            // List all tasks assigned to a user
            listTasksByUser@TaskManager(req4)(res4)
            println@Console( "\nID | Title | Description | Date | Assigned to | Status" )();
            println@Console( "--------------------------------------------------------" )();
            println@Console( res4 )()

        } else if (option == "5") {
            println@Console( "Enter task title:" )();
            readLine@Console()(reqTask.title);
            println@Console( "Enter user name who is assigned now the task:" )();
            readLine@Console()(reqTask.assignedTo);
            req5.name = reqTask.assignedTo;
            println@Console( "Enter user ID who is assigned now the task:" )();
            readLine@Console()(reqTask.userId);
            reqTask.userId = int(reqTask.userId);
            req5.id = reqTask.userId;

            // Check if the user is registered in the system
            checkUser@UserManager(req5)(res5);
            if (res5.userRegistered == true) {
                // Modify task user
                modifyTaskUser@TaskManager(reqTask);
                println@Console( "Task user modified correctly!" )()
            } else {
                println@Console( "The user you want to assign this task is not registered" )()
            }

        } else if (option == "6") {
            println@Console( "Enter task title:" )();
            readLine@Console()(req6.title);
            println@Console( "Enter new task status [pending, completed, in-progress, canceled]:" )();
            readLine@Console()(req6.status);

            // Modify task status
            modifyTaskStatus@TaskManager(req6);
            println@Console( "Task status modified correctly!" )()

        } else if (option == "7") {
            println@Console( "Enter User ID:" )();
            readLine@Console()(req7.userId);
            req7.userId = int(req7.userId);
            println@Console( "Enter username:" )();
            readLine@Console()(req7.name);

            // Show notifications historial of a user
            notificationsHistorialByUser@NotificationManager(req7)(res7);
            println@Console( "\nID | Message" )();
            println@Console( "----------------" )();
            println@Console( res7 )()

        } else if (option == "8") {
            println@Console( "Goodbye!" )()

        } else {
            println@Console( "Invalid option" )()
        }
    }
}