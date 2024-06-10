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
        global.task_iter = 1
    }

    main {
        [createTask(req)] {
            synchronized( token ) {
                // Store task in a list of tasks
                task.id[global.task_iter] = global.task_iter
                task.title[global.task_iter] = req.title
                task.description[global.task_iter] = req.description
                task.dueDate[global.task_iter] = req.date
                task.assignedTo[global.task_iter] = req.assignedTo
                task.status[global.task_iter] = "in-progress"

                global.task_iter++
            }
        }

        [modifyTaskUser(req)] {
            // Modify task user
            task.assignedTo[req.id] = req.assignedTo
        }

        [modifyTaskStatus(req)] {
            // Modify task status
            task[req.id].status = req.status
        }

        [deleteTask(req)] {
            synchronized( token ) {
                global.task_iter--

                // Shift the last task to the deleted task position
                task.id[req.id] = task.id[global.task_iter]
                task.title[req.id] = task.title[global.task_iter]
                task.description[req.id] = task.description[global.task_iter]
                task.dueDate[req.id] = task.dueDate[global.task_iter]
                task.assignedTo[req.id] = task.assignedTo[global.task_iter]
                task.status[req.id] = task.status[global.task_iter]
            }
        }

        [listAllTasks(req)(res)] {
            synchronized( token ) {
                // List all tasks
                println@Console("Listing all tasks...")()

                for (j = 0, j < global.task_iter, j++) {
                    println@Console(
                        "Task ID: " + task.id[global.task_iter] + ", Title: " + task.title[global.task_iter] + ", Assigned to: " + task.assignedTo[global.task_iter] + ", Status: " + task.status[global.task_iter]
                    )()
                }
            }
        }

        [listTasksByUser(req)(res)] {
            synchronized( token ) {
                // List tasks by user
                println@Console("Listing tasks by user: " + req.assignedTo)()

                for (j = 0, j < global.task_iter, j++) {
                    if (TaskRequest.assignedTo[j] == req.assignedTo) {
                        println@Console("Task ID: " + task.id[j] + ", Title: " + task.title[j] + ", Assigned to: " + task.assignedTo[j] + ", Status: " + task.status[j])()
                    }
                }
            }
        }
    }
}