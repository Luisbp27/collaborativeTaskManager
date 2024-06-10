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
            global.tasks.assignedTo[req.id] = req.assignedTo
        }

        [modifyTaskStatus(req)] {
            // Modify task status
            global.tasks.status[req.id] = req.status
        }

        [deleteTask(req)] {
            synchronized( token ) {
                global.task_iter--

                // Shift the last task to the deleted task position
                global.tasks.id[req.id] = global.tasks.id[global.task_iter]
                global.tasks.title[req.id] = global.tasks.title[global.task_iter]
                global.tasks.description[req.id] = global.tasks.description[global.task_iter]
                global.tasks.dueDate[req.id] = global.tasks.dueDate[global.task_iter]
                global.tasks.assignedTo[req.id] = global.tasks.assignedTo[global.task_iter]
                global.tasks.status[req.id] = global.tasks.status[global.task_iter]
            }
        }

        [listAllTasks()] {
            synchronized( token ) {
                // List all tasks
                println@Console( "Listing all global.tasks...\n" )()

                for (j = 0, j < global.task_iter, j++) {
                    println@Console(
                        "User ID: " + global.tasks.userId[global.task_iter] +
                        "\nTitle: " + global.tasks.title[global.task_iter] +
                        "\nDescription: " + global.tasks.description[global.task_iter] +
                        "\nDate: " + global.tasks.date[global.task_iter] +
                        "\nAssigned to: " + global.tasks.assignedTo[global.task_iter] +
                        "\nStatus: " + global.tasks.status[global.task_iter]
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
                            "\nDescription: " + global.tasks.description[j] +
                            "\nDate: " + global.tasks.date[j] +
                            "\nAssigned to: " + global.tasks.assignedTo[j] +
                            "\nStatus: " + global.tasks.status[j])()
                    }
                }
            }
        }
    }
}