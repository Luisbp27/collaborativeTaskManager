include "console.iol"
include "http.iol"

type TaskRequest: void {
    .title: string,
    .description: string,
    .dueDate: string,
    .assignedTo: string
}

type TaskResponse: void {
    .message: string
}

interface TaskServiceInterface {
    RequestResponse: createTask(TaskRequest)(TaskResponse)
}

inputPort TaskServicePort {
    location: "socket://localhost:1234"
    protocol: http
    interfaces: TaskServiceInterface
}

outputPort Console {
    location: "local://console"
    protocol: sodep
    interfaces: ConsoleInterface
}

main {
    createTask(req)(res) {
        // Store task in a database (simplified here as a console log)
        Console.log@println("Task Created: " + req.title + ", Assigned to: " + req.assignedTo)()
        res.message = "Task successfully created and assigned."
    }
}
