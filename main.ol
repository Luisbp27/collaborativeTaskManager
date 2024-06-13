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
    println@Console( "- WELCOME TO COLLABORATIVE TASK MANAGER -" )();

    registration = false;
    while(registration == false) {
        println@Console( "\nDo you have a user registered? (y: Yes, n: No): " )();
        readLine@Console()(answer);

        if (answer == "y") {
            oportunities = 3;
            while (res.userRegistered == false && oportunities > 0) {
                oportunities--;
                println@Console( "Enter your ID:" )();
                readLine@Console()(req.id);
                req.id = int(req.id);
                println@Console( "Enter username:" )();
                readLine@Console()(req.name);
                println@Console( "Enter password:" )();
                readLine@Console()(req.password);

                // Check if the user is registered in the system
                authUser@UserManager(req)(res)
                if (res.userRegistered == false) {
                    println@Console( "Something goes wrong, try again! Oportunities: " + oportunities + "\n" )()
                }
            }

            if (oportunities == 0) {
                println@Console( "You have exceeded the number of attempts" )();
                exit
            }

            println@Console( "Welcome!" )()
            registration = true

        } else if (answer == "n") {
            println@Console( "Registering a new user..." )();
            println@Console( "Enter username:" )();
            readLine@Console()(reqNew.name);
            println@Console( "Enter password:" )();
            readLine@Console()(reqNew.password);
            println@Console( "Enter email:" )();
            readLine@Console()(reqNew.email);

            // Check if there is a user with the same name
            reqCheck.name = reqNew.name;
            checkUser@UserManager(reqCheck)(resCheck);
            if (resCheck.userRegistered == true) {
                println@Console( "The username is already in use, try again!" )()
            } else {
                // Register a new user
                registerUser@UserManager(reqNew)(resNew);
                println@Console( "\nUser registered correctly, your ID is: " + resNew.id )();
                println@Console( "Welcome!" )()

                registration = true
            }
        } else {
            println@Console( "Invalid option, try again!" )()
        }
    }
}

main {

    option = "0";
    while (option != "8") {
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

        // Create a new task
        if (option == "1") {
            // Request data
            println@Console( "Enter your ID:" )();
            readLine@Console()(req1.userId);
            req1.userId = int(req1.userId);
            println@Console( "Enter a task title:" )();
            readLine@Console()(req1.title);
            println@Console( "Enter a task description:" )();
            readLine@Console()(req1.description);
            println@Console( "Enter today date (format: DD/MM/YYYY):" )();
            readLine@Console()(req1.date);
            println@Console( "Enter who the task is assigned to:" )();
            readLine@Console()(req1.assignedTo);

            // Check if the user is registered in the system
            reqCheck1.name = req1.assignedTo;
            checkUser@UserManager(reqCheck1)(resCheck1);
            if (resCheck1.userRegistered == false) {
                println@Console( "The user you want to assign this task is not registered" )()
            } else {
                // Create a new task
                createTask@TaskManager(req1)
            }

        // Delete a task
        } else if (option == "2") {
            // Request data
            println@Console( "Enter the task title you want to delete:" )();
            readLine@Console()(req2.title);

            // Delete a task
            deleteTask@TaskManager(req2)

        // List all tasks
        } else if (option == "3") {
            listAllTasks@TaskManager()(res3)

            println@Console( "\nID | Title | Description | Date | Assigned to | Status" )();
            println@Console( "--------------------------------------------------------" )();
            println@Console( res3 )()

        // List all tasks assigned to a user
        } else if (option == "4") {
            // Request data
            println@Console( "Enter user ID:" )();
            readLine@Console()(id);
            req4.userId = int(id);
            println@Console( "Enter a username:" )();
            readLine@Console()(name);

            // Check if the user is registered in the system
            reqCheck4.name = name;
            checkUser@UserManager(reqCheck4)(resCheck4);
            if (resCheck4.userRegistered == false) {
                println@Console( "The user you want to list their tasks, is not registered" )()
            } else {
                // List all tasks
                listTasksByUser@TaskManager(req4)(res4)

                println@Console( "\nID | Title | Description | Date | Assigned to | Status" )();
                println@Console( "--------------------------------------------------------" )();
                println@Console( res4 )()
            }

        // Modify task user
        } else if (option == "5") {
            // Request data
            println@Console( "Enter task title:" )();
            readLine@Console()(reqTask.title);
            println@Console( "Enter username who is assigned now the task:" )();
            readLine@Console()(reqTask.assignedTo);
            println@Console( "Enter user ID who is assigned now the task:" )();
            readLine@Console()(reqTask.userId);
            reqTask.userId = int(reqTask.userId);

            // Check if the user is registered in the system
            reqCheck5.name = reqTask.assignedTo;
            checkUser@UserManager(reqCheck5)(resCheck5);
            if (resCheck5.userRegistered == true) {
                // Modify task user
                modifyTaskUser@TaskManager(reqTask)
            } else {
                println@Console( "The user you want to assign this task is not registered" )()
            }

        // Modify task status
        } else if (option == "6") {
            // Request data
            println@Console( "Enter task title:" )();
            readLine@Console()(req6.title);
            println@Console( "Enter new task status [pending, completed, in-progress, canceled]:" )();
            readLine@Console()(req6.status);

            // Modify task status
            modifyTaskStatus@TaskManager(req6)

        // Show notifications historial of a user
        } else if (option == "7") {
            // Request data
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

        // Exit
        } else if (option == "8") {
            println@Console( "Goodbye!" )()

        } else {
            println@Console( "Invalid option" )()
        }
    }
}