include "console.iol"
include "/protocols/http.iol"
include "interfaces/interfaces.iol"
include "interfaces/objects.iol"

service TaskService() {

    execution: concurrent

    outputPort NotificationManager {
        location: "socket://localhost:1236"
        protocol: http
        interfaces: NotificationInterface
    }

    inputPort TaskServicePort {
        location: "socket://localhost:1234"
        protocol: http
        interfaces: TaskServiceInterface
    }

    init {
        global.task_iter = 0 // Task iterator
        global.tasks = Tasks // List of tasks
    }

    main {
        [createTask(req)] {
            synchronized( token ) {
                global.task_iter++

                // Store task in a list of tasks
                global.tasks.id[global.task_iter] = global.task_iter
                global.tasks.userId[global.task_iter] = req.userId
                global.tasks.title[global.task_iter] = req.title
                global.tasks.description[global.task_iter] = req.description
                global.tasks.date[global.task_iter] = req.date
                global.tasks.assignedTo[global.task_iter] = req.assignedTo
                global.tasks.status[global.task_iter] = "in-progress"

                // Send notification
                notReq.userId = global.tasks.userId[global.task_iter]
                notReq.message = "Task with ID: " + global.tasks.id[global.task_iter] + " created successfully by user ID: " + global.tasks.userId[global.task_iter]
                sendNotification@NotificationManager(notReq)
            }
        }

        [modifyTaskUser(req)] {
            found = false
            for (j = 1, j <= global.task_iter && found == false, j++) {
                // If we found a task with the same title
                if (global.tasks.title[j] == req.title) {
                    // Modify task user
                    global.tasks.assignedTo[j] = req.assignedTo
                    found = true

                    // Send notification
                    notReq.userId = global.tasks.userId[j]
                    notReq.message = "Task with ID: " + global.tasks.id[j] + " assigned to user ID: " + global.tasks.assignedTo[j]
                    sendNotification@NotificationManager(notReq)
                }
            }

            // If we didn't find the task we send a notification
            if (!found) {
                notReq.userId = global.tasks.userId[j]
                notReq.message = "Task with title: " + req.title + "not found!"
                sendNotification@NotificationManager(notReq)
            }
        }

        [modifyTaskStatus(req)] {
            synchronized( token ) {
                // Check if there are tasks
                if (global.task_iter <= 0) {
                    // Send notification
                    notReq.userId = int(req.userId)
                    notReq.message = "No tasks found with title: " + req.title
                    sendNotification@NotificationManager(notReq)
                } else {
                    found = false
                    for (j = 1, j <= global.task_iter && found == false, j++) {
                        // If we found a task with the same title we modify the status
                        if (global.tasks.title[j] == req.title) {
                            // Modify task status
                            global.tasks.status[j] = req.status
                            found = true

                            // Send notification
                            notReq.userId = global.tasks.userId[j]
                            notReq.message = "Task with ID: " + global.tasks.id[j] + " status changed to: " + global.tasks.status[j]
                            sendNotification@NotificationManager(notReq)
                        }
                    }

                    if (!found) {
                        // Send notification
                        notReq.userId = global.tasks.userId[j]
                        notReq.message = "Task with title: " + req.title + "not found!"
                        sendNotification@NotificationManager(notReq)
                    }
                }
            }
        }

        [deleteTask(req)] {
            synchronized( token ) {
                // Check if there are tasks
                if (global.task_iter <= 0) {
                    // Send notification
                    notReq.userId = int(req.userId)
                    notReq.message = "No tasks found with title: " + req.title
                    sendNotification@NotificationManager(notReq)
                } else {
                    found = false
                    for (j = 1, j <= global.task_iter && found == false, j++) {
                        // If we found a task with the same title we delete it
                        if (global.tasks.title[j] == req.title) {
                            // Shift the last task to the deleted task position
                            global.tasks.userId[j] = global.tasks.userId[global.task_iter]
                            global.tasks.title[j] = global.tasks.title[global.task_iter]
                            global.tasks.description[j] = global.tasks.description[global.task_iter]
                            global.tasks.date[j] = global.tasks.date[global.task_iter]
                            global.tasks.assignedTo[j] = global.tasks.assignedTo[global.task_iter]
                            global.tasks.status[j] = global.tasks.status[global.task_iter]

                            found = true

                            // Send notification
                            notReq.userId = int(req.userId)
                            notReq.message = "Task with title: " + req.title + " deleted successfully!"
                            sendNotification@NotificationManager(notReq)

                            global.task_iter--
                        }
                    }

                    // If we didn't find the task we send a notification
                    if (!found) {
                        notReq.userId = int(req.userId)
                        notReq.message = "Task with title: " + req.title + " not founded to delete it!"
                        sendNotification@NotificationManager(notReq)
                    }
                }
            }
        }

        [listAllTasks()(tasks) {
            synchronized( token ) {
                // Check if there are tasks
                if (global.task_iter <= 0) {
                    tasks = "No tasks found!"
                } else {
                    // List all tasks
                    tasks = ""
                    for (j = 1, j <= global.task_iter, j++) {
                        tasks += " " + global.tasks.id[j] +
                                " " + global.tasks.title[j] +
                                " " + global.tasks.description[j] +
                                " " + global.tasks.date[j] +
                                " " + global.tasks.assignedTo[j] +
                                " " + global.tasks.status[j] + "\n"
                    }
                }
            }
        }]

        [listTasksByUser(req)(tasks) {
            synchronized( token ) {
                // Search the number of tasks of the user
                task_iter = 0
                for (j = 1, j <= global.task_iter, j++) {
                    if (global.tasks.userId[j] == req.userId) {
                        task_iter++
                    }
                }

                // Check if there are tasks
                if (task_iter <= 0) {
                    tasks = "No tasks found!"
                } else {
                    // List tasks
                    tasks = ""
                    for (j = 1, j <= global.task_iter, j++) {
                        if (global.tasks.userId[j] == req.userId) {
                            tasks += " " + global.tasks.id[j] +
                                " " + global.tasks.title[j] +
                                " " + global.tasks.description[j] +
                                " " + global.tasks.date[j] +
                                " " + global.tasks.assignedTo[j] +
                                " " + global.tasks.status[j] + "\n"
                        }
                    }
                }
            }
        }]
    }
}