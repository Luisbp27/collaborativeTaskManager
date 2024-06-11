include "console.iol"
include "/protocols/http.iol"
include "interfaces/interfaces.iol"
include "interfaces/objects.iol"

service TaskService() {

    execution: concurrent

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
                println@Console( "Creating task..." )()
                global.tasks.id[global.task_iter] = global.task_iter
                global.tasks.userId[global.task_iter] = req.userId
                global.tasks.title[global.task_iter] = req.title
                global.tasks.description[global.task_iter] = req.description
                global.tasks.date[global.task_iter] = req.date
                global.tasks.assignedTo[global.task_iter] = req.assignedTo
                global.tasks.status[global.task_iter] = "in-progress"
                println@Console( "Task created successfully!" )()

                global.task_iter++
            }
        }

        [modifyTaskUser(req)] {
            // Modify task user
            global.tasks.assignedTo[req.userId] = req.assignedTo
        }

        [modifyTaskStatus(req)] {
            // Modify task status
            global.tasks.status[req.userId] = req.status
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