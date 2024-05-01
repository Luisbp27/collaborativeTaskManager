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

interface TaskServiceInterface {
    RequestResponse:
    createTask(TaskRequest)(TaskResponse),
    modifyTaskStatus(TaskRequest)(TaskResponse),
    deleteTask(TaskRequest)(TaskResponse),
    listAllTasks(TaskRequest)(TaskResponse),
    listTasksByUser(TaskRequest)(TaskResponse)
}

inputPort TaskServicePort {
    location: "socket://localhost:1234"
    protocol: http
    interfaces: TaskServiceInterface
}

main {
    i = 0
    createTask(req)(res) {
        // Store task in a list of tasks
        TaskRequest.id[i] = i
        TaskRequest.title[i] = req.title
        TaskRequest.description[i] = req.description
        TaskRequest.dueDate[i] = req.dueDate
        TaskRequest.assignedTo[i] = req.assignedTo
        TaskRequest.status[i] = req.status

        i = i + 1

        println@Console("Task Created: " + req.title + ", Assigned to: " + req.assignedTo)()
        res.message = "Task successfully created and assigned."
    }

    modifyTaskStatus(req)(res) {
        // Modify task status
        TaskRequest.status[req.id] = req.status

        println@Console("Task Status Modified: " + req.title + ", New Status: " + req.status)()
        res.message = "Task status successfully modified."
    }

    deleteTask(req)(res) {
        // Shift the last task to the deleted task position
        TaskRequest.id[req.id] = TaskRequest.id[i - 1]
        TaskRequest.title[req.id] = TaskRequest.title[i - 1]
        TaskRequest.description[req.id] = TaskRequest.description[i - 1]
        TaskRequest.dueDate[req.id] = TaskRequest.dueDate[i - 1]
        TaskRequest.assignedTo[req.id] = TaskRequest.assignedTo[i - 1]
        TaskRequest.status[req.id] = TaskRequest.status[i - 1]

        i = i - 1

        println@Console("Task Deleted: " + req.title)()
        res.message = "Task successfully deleted."
    }

    listAllTasks(req)(res) {
        // List all tasks
        println@Console("Listing all tasks...")()

        for (j = 0, j < i, j++) {
            println@Console("Task ID: " + TaskRequest.id[i] + ", Title: " + TaskRequest.title[i] + ", Assigned to: " + TaskRequest.assignedTo[i] + ", Status: " + TaskRequest.status[i])()
        }

        res.message = "Tasks listed correctly."
    }

    listTasksByUser(req)(res) {
        // List tasks by user
        println@Console("Listing tasks by user: " + req.assignedTo)()

        for (j = 0, j < i, j++) {
            if (TaskRequest.assignedTo[j] == req.assignedTo) {
                println@Console("Task ID: " + TaskRequest.id[j] + ", Title: " + TaskRequest.title[j] + ", Assigned to: " + TaskRequest.assignedTo[j] + ", Status: " + TaskRequest.status[j])()
            }
        }

        res.message = "Tasks listed."
    }

}
