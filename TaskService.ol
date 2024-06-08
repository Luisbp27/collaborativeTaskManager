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
        [createTask(req)(res) {
            synchronized( token ) {
                // Store task in a list of tasks
                task[global.task_iter].id = global.task_iter
                task[global.task_iter].title = req.title
                task[global.task_iter].description = req.description
                task[global.task_iter].dueDate = req.dueDate
                task[global.task_iter].assignedTo = req.assignedTo
                task[global.task_iter].status = req.status

                global.task_iter++

                println@Console("Task Created: " + req.title + ", Assigned to: " + req.assignedTo)()
                res.message = "Task successfully created and assigned."
            }
        }]

        [modifyTaskUser(req)(res) {
            // Modify task user
            task[req.id].assignedTo = req.assignedTo

            println@Console("Task User Modified: " + req.title + ", New User: " + req.assignedTo)()
            res.message = "Task user successfully modified."
        }]

        [modifyTaskStatus(req)(res) {
            // Modify task status
            task[req.id].status = req.status

            println@Console("Task Status Modified: " + req.title + ", New Status: " + req.status)()
            res.message = "Task status successfully modified."
        }]

        [deleteTask(req)(res) {
            synchronized( token ) {
                global.task_iter--

                // Shift the last task to the deleted task position
                task[req.id].id = task[global.task_iter].id
                task[req.id].title = task[global.task_iter].title
                task[req.id].description = task[global.task_iter].description
                task[req.id].dueDate = task[global.task_iter].dueDate
                task[req.id].assignedTo = task[global.task_iter].assignedTo
                task[req.id].status = task[global.task_iter].status

                println@Console("Task Deleted: " + req.title)()
                res.message = "Task successfully deleted."
            }
        }]

        [listAllTasks(req)(res) {
            synchronized( token ) {
                // List all tasks
                println@Console("Listing all tasks...")()

                for (j = 0, j < global.task_iter, j++) {
                    println@Console(
                        "Task ID: " + task[global.task_iter].id + ", Title: " + task[global.task_iter].title + ", Assigned to: " + task[global.task_iter].assignedTo + ", Status: " + task[global.task_iter].status
                    )()
                }

                res.message = "Tasks listed correctly."
            }

        }]

        [listTasksByUser(req)(res) {
            synchronized( token ) {
                // List tasks by user
                println@Console("Listing tasks by user: " + req.assignedTo)()

                for (j = 0, j < global.task_iter, j++) {
                    if (TaskRequest[j].assignedTo == req.assignedTo) {
                        println@Console("Task ID: " + task[j].id + ", Title: " + task[j].title + ", Assigned to: " + task[j].assignedTo + ", Status: " + task[j].status)()
                    }
                }

                res.message = "Tasks listed."
            }
        }]
    }
}