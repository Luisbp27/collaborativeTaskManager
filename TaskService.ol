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
    }

    main {
        [createTask(req)] {
            synchronized( token ) {
                // Store task in a list of tasks
                println@Console( "Creating task..." )()
                tasks.userId[global.task_iter] = req.userId
                tasks.title[global.task_iter] = req.title
                tasks.description[global.task_iter] = req.description
                tasks.date[global.task_iter] = req.date
                tasks.assignedTo[global.task_iter] = req.assignedTo
                tasks.status[global.task_iter] = "in-progress"
                println@Console( "Task created successfully!" )()

                global.task_iter++
            }
        }

        [modifyTaskUser(req)] {
            // Modify task user
            tasks.assignedTo[req.id] = req.assignedTo
        }

        [modifyTaskStatus(req)] {
            // Modify task status
            tasks.status[req.id] = req.status
        }

        [deleteTask(req)] {
            synchronized( token ) {
                global.task_iter--

                // Shift the last task to the deleted task position
                tasks.id[req.id] = tasks.id[global.task_iter]
                tasks.title[req.id] = tasks.title[global.task_iter]
                tasks.description[req.id] = tasks.description[global.task_iter]
                tasks.dueDate[req.id] = tasks.dueDate[global.task_iter]
                tasks.assignedTo[req.id] = tasks.assignedTo[global.task_iter]
                tasks.status[req.id] = tasks.status[global.task_iter]
            }
        }

        [listAllTasks()] {
            synchronized( token ) {
                // List all tasks
                println@Console( "Listing all tasks...\n" )()

                for (j = 0, j < global.task_iter, j++) {
                    println@Console(
                        "User ID: " + tasks.userId[global.task_iter] +
                        "\nTitle: " + tasks.title[global.task_iter] +
                        "\nDescription: " + tasks.description[global.task_iter] +
                        "\nDate: " + tasks.date[global.task_iter] +
                        "\nAssigned to: " + tasks.assignedTo[global.task_iter] +
                        "\nStatus: " + tasks.status[global.task_iter]
                    )()
                }
            }
        }

        [listTasksByUser(req)] {
            synchronized( token ) {
                // List tasks by user
                println@Console("Listing tasks by user: " + req.assignedTo)()

                for (j = 0, j < global.task_iter, j++) {
                    if (TaskRequest.assignedTo[j] == req.assignedTo) {
                        println@Console(
                            "Title: " + s.title[j] +
                            "\nDescription: " + tasks.description[j] +
                            "\nDate: " + tasks.date[j] +
                            "\nAssigned to: " + tasks.assignedTo[j] +
                            "\nStatus: " + tasks.status[j])()
                    }
                }
            }
        }
    }
}