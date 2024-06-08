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
        [registerUser(req) {
            synchronized( token ) {
                // Adding user
                println@Console("Registering user " + req.username + " with id " + req.userId)
                users[global.user_iter].username = req.username
                users[global.user_iter].id = req.userId
                global.user_iter++

                // Send notification
                //req.userId = users.id[global.user_iter]
                //res.message = "User registered successfully."
                //sendNotification@NotificationManager(req)(res)
            }
        }]

        [authUser(req)(res) {
            synchronized( token ) {
                // Check if the user is in the list
                found = false
                j = 0
                while (found == false && j < global.user_iter) {
                    if (users[j].username == req.username) {
                        found = true
                    }
                    j = j + 1
                }

                // Send response
                if (found == false) {
                    res.userRegistered = false
                    println@Console("User " + req.username + " is not registered.")
                } else {
                    res.userRegistered = true
                    println@Console("User " + req.username + " is registered.")
                }
            }
        }]

        [deleteUser(req)(res) {
            synchronized( token ) {
                j = req.userId

                // Delete user
                users[j].username = ""
                users[j].id = -1

                // Get the last user and move it to the deleted user position
                users[j].username = users[global.user_iter].username
                users[j].id = users[global.user_iter].id
                global.user_iter--

                // Delete all the notifications of the deleted user
                // deleteAllNotificationsByUser@NotificationManager(req)(res)
            }
        }]
    }
}