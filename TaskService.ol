include "console.iol"
include "/protocols/http.iol"

type TaskRequest: void {
    id : int
    title: string
    description: string
    dueDate: string
    assignedTo: string
    status: string
}

type TaskResponse: void {
    message: string
}

type Task: void {
    id: int
    title: string
    description: string
    dueDate: string
    assignedTo: string
    status: string
}

type Tasks: void {
    task*: Task
}

service TaskService() {

    execution: concurrent

    inputPort TaskServicePort {
        location: "socket://localhost:1234"
        protocol: http
        interfaces: TaskServiceInterface
    }

    main {
        i = 0
        createTask(req)(res) {
            // Store task in a list of tasks
            task.id[i] = i
            task.title[i] = req.title
            task.description[i] = req.description
            task.dueDate[i] = req.dueDate
            task.assignedTo[i] = req.assignedTo
            task.status[i] = req.status

            i = i + 1

            println@Console("Task Created: " + req.title + ", Assigned to: " + req.assignedTo)()
            res.message = "Task successfully created and assigned."
        }

        modifyTaskUser(req)(res) {
            // Modify task user
            task.assignedTo[req.id] = req.assignedTo

            println@Console("Task User Modified: " + req.title + ", New User: " + req.assignedTo)()
            res.message = "Task user successfully modified."
        }

        modifyTaskStatus(req)(res) {
            // Modify task status
            task.status[req.id] = req.status

            println@Console("Task Status Modified: " + req.title + ", New Status: " + req.status)()
            res.message = "Task status successfully modified."
        }

        deleteTask(req)(res) {
            // Shift the last task to the deleted task position
            task.id[req.id] = task.id[i - 1]
            task.title[req.id] = task.title[i - 1]
            task.description[req.id] = task.description[i - 1]
            task.dueDate[req.id] = task.dueDate[i - 1]
            task.assignedTo[req.id] = task.assignedTo[i - 1]
            task.status[req.id] = task.status[i - 1]

            i = i - 1

            println@Console("Task Deleted: " + req.title)()
            res.message = "Task successfully deleted."
        }

        listAllTasks(req)(res) {
            // List all tasks
            println@Console("Listing all tasks...")()

            for (j = 0, j < i, j++) {
                println@Console("Task ID: " + task.id[i] + ", Title: " + task.title[i] + ", Assigned to: " + task.assignedTo[i] + ", Status: " + task.status[i])()
            }

            res.message = "Tasks listed correctly."
        }

        listTasksByUser(req)(res) {
            // List tasks by user
            println@Console("Listing tasks by user: " + req.assignedTo)()

            for (j = 0, j < i, j++) {
                if (TaskRequest.assignedTo[j] == req.assignedTo) {
                    println@Console("Task ID: " + task.id[j] + ", Title: " + task.title[j] + ", Assigned to: " + task.assignedTo[j] + ", Status: " + task.status[j])()
                }
            }

            res.message = "Tasks listed."
        }
    }
}