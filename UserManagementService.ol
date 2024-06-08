include "console.iol"
include "/protocols/http.iol"
include "interfaces/interfaces.iol"
include "interfaces/objects.iol"


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

    init {
        global.user_iter = 0
    }

    main {
        [registerUser(req)(res) {
            // Adding user
            users.username[global.user_iter] = req.username
            users.id[global.user_iter] = req.userId
            global.user_iter++

            // Send notification
            req.userId = users.id[global.user_iter]
            req.message = "User registered successfully."
            sendNotification@NotificationManager(req)(res)
        }]

        [authUser(req)(res) {
            // Check if the user is in the list
            found = false
            j = 0
            while (found == false && j < global.user_iter) {
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
        }]

        [deleteUser(req)(res) {
            j = req.userId

            // Delete user
            users.username[j] = ""
            users.id[j] = 0

            // Get the last user and move it to the deleted user position
            users.username[j] = users.username[global.user_iter]
            users.id[j] = users.id[global.user_iter]
            global.user_iter--

            // Delete all the notifications of the deleted user
            deleteAllNotificationsByUser@NotificationManager(req)(res)
        }]
    }
}