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
            // Store task in a list of tasks
            id = global.task_iter
            task.id[id] = id
            task.title[id] = req.title
            task.description[id] = req.description
            task.dueDate[id] = req.dueDate
            task.assignedTo[id] = req.assignedTo
            task.status[id] = req.status

            global.task_iter++

            println@Console("Task Created: " + req.title + ", Assigned to: " + req.assignedTo)()
            res.message = "Task successfully created and assigned."
        }]

        [modifyTaskUser(req)(res) {
            // Modify task user
            task.assignedTo[req.id] = req.assignedTo

            println@Console("Task User Modified: " + req.title + ", New User: " + req.assignedTo)()
            res.message = "Task user successfully modified."
        }]

        [modifyTaskStatus(req)(res) {
            // Modify task status
            task.status[req.id] = req.status

            println@Console("Task Status Modified: " + req.title + ", New Status: " + req.status)()
            res.message = "Task status successfully modified."
        }]

        [deleteTask(req)(res) {
            id_ = global.task_iter - 1
            // Shift the last task to the deleted task position
            task.id[req.id] = task.id[id_]
            task.title[req.id] = task.title[id_]
            task.description[req.id] = task.description[id_]
            task.dueDate[req.id] = task.dueDate[id_]
            task.assignedTo[req.id] = task.assignedTo[id_]
            task.status[req.id] = task.status[id_]

            global.task_iter--

            println@Console("Task Deleted: " + req.title)()
            res.message = "Task successfully deleted."
        }]

        [listAllTasks(req)(res) {
            // List all tasks
            println@Console("Listing all tasks...")()

            id = global.task_iter

            for (j = 0, j < id, j++) {
                println@Console(
                    "Task ID: " + task.id[id] + ", Title: " + task.title[id] + ", Assigned to: " + task.assignedTo[id] + ", Status: " + task.status[id]
                )()
            }

            res.message = "Tasks listed correctly."
        }]

        [listTasksByUser(req)(res) {
            // List tasks by user
            println@Console("Listing tasks by user: " + req.assignedTo)()

            for (j = 0, j < global.task_iter, j++) {
                if (TaskRequest.assignedTo[j] == req.assignedTo) {
                    println@Console("Task ID: " + task.id[j] + ", Title: " + task.title[j] + ", Assigned to: " + task.assignedTo[j] + ", Status: " + task.status[j])()
                }
            }

            res.message = "Tasks listed."
        }]
    }
}