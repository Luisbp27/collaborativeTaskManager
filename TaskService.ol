include "console.iol"
include "/protocols/http.iol"
include "interfaces/interfaces.iol"
include "interfaces/objects.iol"

service TaskService() {

    execution: concurrent

    outputPort NotificationManager {
        location: "socket://localhost:1236"
        protocol: http
        interfaces: NotificationInterface
    }

    inputPort TaskServicePort {
        location: "socket://localhost:1234"
        protocol: http
        interfaces: TaskServiceInterface
    }

    init {
        global.task_iter = 0
        global.tasks = Tasks
    }

    main {
        [createTask(req)] {
            synchronized( token ) {
                // Store task in a list of tasks
                global.tasks.id[global.task_iter] = global.task_iter
                global.tasks.userId[global.task_iter] = req.userId
                global.tasks.title[global.task_iter] = req.title
                global.tasks.description[global.task_iter] = req.description
                global.tasks.date[global.task_iter] = req.date
                global.tasks.assignedTo[global.task_iter] = req.assignedTo
                global.tasks.status[global.task_iter] = "in-progress"

                // Send notification
                notReq.userId = global.tasks.userId[global.task_iter]
                notReq.message = "Task with ID: " + global.tasks.id[global.task_iter] + " created successfully by user ID: " + global.tasks.userId[global.task_iter]
                sendNotification@NotificationManager(notReq)

                global.task_iter++
            }
        }

        [modifyTaskUser(req)] {
            // Search ID task by title
            found = false
            for (j = 0, j < global.task_iter, j++) {
                if (global.tasks.title[j] == req.title) {
                    // Modify task user
                    global.tasks.assignedTo[j] = req.assignedTo
                    found = true

                    // Send notification
                    notReq.userId = global.tasks.userId[j]
                    notReq.message = "Task with ID: " + global.tasks.id[j] + " assigned to user ID: " + global.tasks.assignedTo[j]
                    sendNotification@NotificationManager(notReq)
                }
            }

            if (!found) {
                // Send notification
                notReq.userId = global.tasks.userId[j]
                notReq.message = "Task with title: " + req.title + "not found!"
                sendNotification@NotificationManager(notReq)
            }
        }

        [modifyTaskStatus(req)] {
            // Search ID task by title
            found = false
            for (j = 0, j < global.task_iter, j++) {
                if (global.tasks.title[j] == req.title) {
                    // Modify task status
                    global.tasks.status[j] = req.status
                    found = true

                    // Send notification
                    notReq.userId = global.tasks.userId[j]
                    notReq.message = "Task with ID: " + global.tasks.id[j] + " status changed to: " + global.tasks.status[j]
                    sendNotification@NotificationManager(notReq)
                }
            }

            if (!found) {
                // Send notification
                notReq.userId = global.tasks.userId[j]
                notReq.message = "Task with title: " + req.title + "not found!"
                sendNotification@NotificationManager(notReq)
            }
        }

        [deleteTask(req)] {
            synchronized( token ) {
                // Search for task by user ID
                for (j = 0, j < global.task_iter, j++) {
                    if (global.tasks.title[j] == req.title) {
                        // If there is only one task, delete it
                        if (global.task_iter == 1) {
                            global.task_iter--
                            println@Console( "Task deleted successfully!" )()
                        } else {
                            // Shift the last task to the deleted task position
                            global.tasks.userId[j] = global.tasks.userId[global.task_iter]
                            global.tasks.title[j] = global.tasks.title[global.task_iter]
                            global.tasks.description[j] = global.tasks.description[global.task_iter]
                            global.tasks.date[j] = global.tasks.date[global.task_iter]
                            global.tasks.assignedTo[j] = global.tasks.assignedTo[global.task_iter]
                            global.tasks.status[j] = global.tasks.status[global.task_iter]

                            global.task_iter--
                            println@Console( "Task deleted successfully!" )()
                        }
                    } else {
                        println@Console( "Task not found!" )()
                    }
                }

            }
        }

        [listAllTasks()] {
            synchronized( token ) {
                // List all tasks
                println@Console( "Listing all tasks...\n" )()

                for (j = 0, j < global.task_iter, j++) {
                    println@Console(
                        "Task ID: " + global.tasks.id[j] +
                        "\nUser ID: " + global.tasks.userId[j] +
                        "\nTitle: " + global.tasks.title[j] +
                        "\nDescription: " + global.tasks.description[j] +
                        "\nDate: " + global.tasks.date[j] +
                        "\nAssigned to: " + global.tasks.assignedTo[j] +
                        "\nStatus: " + global.tasks.status[j] + "\n"
                    )()
                }
            }
        }

        [listTasksByUser(req)] {
            synchronized( token ) {
                // List tasks by user
                println@Console("Listing tasks by user ID: " + req.userId)()

                for (j = 0, j < global.task_iter, j++) {
                    if (global.tasks.userId[j] == req.userId) {
                        println@Console(
                            "Task ID: " + global.tasks.id[j] +
                            "\nTitle: " + global.tasks.title[j] +
                            "\nDescription: " + global.tasks.description[j] +
                            "\nDate: " + global.tasks.date[j] +
                            "\nAssigned to: " + global.tasks.assignedTo[j] +
                            "\nStatus: " + global.tasks.status[j] + "\n"
                        )()
                    }
                }
            }
        }
    }
}