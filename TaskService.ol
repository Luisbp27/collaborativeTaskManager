include "console.iol"
include "/protocols/http.iol"

type TaskRequest: void {
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
    createTask(req)(res) {
        // Store task in a list of tasks
        println@Console("Task Created: " + req.title + ", Assigned to: " + req.assignedTo)()
        res.message = "Task successfully created and assigned."
    }

    modifyTaskStatus(req)(res) {
        // Modify task status
        println@Console("Task Status Modified: " + req.title + ", New Status: " + req.status)()
        res.message = "Task status successfully modified."
    }

    deleteTask(req)(res) {
        // Delete task
        println@Console("Task Deleted: " + req.title)()
        res.message = "Task successfully deleted."
    }

    listAllTasks(req)(res) {
        // List all tasks
        println@Console("Listing all tasks...")()
        res.message = "Tasks listed."
    }

    listTasksByUser(req)(res) {
        // List tasks by user
        println@Console("Listing tasks by user: " + req.assignedTo)()
        res.message = "Tasks listed."
    }

}
