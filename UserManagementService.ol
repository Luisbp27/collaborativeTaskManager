include "console.iol"
include "/protocols/http.iol"
include "interfaces.iol"

type UserRequest: void {
    userId: int
    username: string
    password: string
    email: string
}

type UserResponse: void {
    userRegistered : bool
    message: string
}

type User: void {
    id: int
    username: string
    password: string
    email: string
}

type Users: void {
    users*: User
}

outputPort NotificationManager {
    location: "socket://localhost:1236"
    protocol: http
    interfaces: NotificationInterface
}

service UserManagementService() {

    execution: concurrent

    inputPort UserManagementPort {
        location: "socket://localhost:1235"
        protocol: http
        interfaces: UserManagementInterface
    }

    main {
        i = 0
        registerUser(req)(res) {
            // Adding user
            users.username[i] = req.username
            users.id[i] = req.userId
            i = i + 1

            // Send notification
            req.userId = users.id[i]
            req.message = "User registered successfully."
            sendNotification@NotificationManager(req)(res)
        }

        authUser(req)(res) {
            // Check if the user is in the list
            found = false
            j = 0
            while (found == false && j < i) {
                if (users.username[j] == req.username) {
                    found = true
                }
                j = j + 1
            }

            // Send response
            if (found == false) {
                res.userRegistered = false
                res.message = "User " + req.username + " is not registered."
            } else {
                res.userRegistered = true
                res.message = "User " + req.username + " is registered."
            }
        }

        deleteUser(req)(res) {
            j = req.userId

            // Delete user
            users.username[j] = ""
            users.id[j] = 0

            // Get the last user and move it to the deleted user position
            users.username[j] = users.username[i]
            users.id[j] = users.id[i]
            i = i - 1

            // Delete all the notifications of the deleted user
            deleteAllNotificationsByUser@NotificationManager(req)(res)
            println@Console(res.message)
        }
    }
}