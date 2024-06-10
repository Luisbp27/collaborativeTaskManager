include "console.iol"
include "/protocols/http.iol"
include "interfaces/interfaces.iol"
include "interfaces/objects.iol"


service UserManagementService() {

    execution: concurrent

    outputPort NotificationManager {
        location: "socket://localhost:1236"
        protocol: http
        interfaces: NotificationInterface
    }

    inputPort UserManagementPort {
        location: "socket://localhost:1235"
        protocol: http
        interfaces: UserManagementInterface
    }

    init {
        global.user_iter = 0
    }

    main {
        [registerUser(req)] {
            synchronized( token ) {
                // Adding user to the list
                users[global.user_iter].name = req.name
                users[global.user_iter].id = req.id
                global.user_iter++

                // Send notification
                req.id = users.id[global.user_iter]
                sendNotification@NotificationManager(req)
            }
        }

        [authUser(req)(res)] {
            synchronized( token ) {
                // Check if the user is in the list
                found = false
                j = 0
                while (found == false && j < global.user_iter) {
                    if (users[j].name == req.name) {
                        found = true
                    }
                    j = j + 1
                }

                // Send response
                if (found == false) {
                    res.userRegistered = false
                } else {
                    res.userRegistered = true
                }
            }
        }

        [deleteUser(req)] {
            synchronized( token ) {
                j = req.id

                // Delete user
                users[j].name = ""
                users[j].id = -1

                // Get the last user and move it to the deleted user position
                users[j].name = users[global.user_iter].name
                users[j].id = users[global.user_iter].id
                global.user_iter--

                // Delete all the notifications of the deleted user
                deleteAllNotificationsByUser@NotificationManager(req)
            }
        }
    }
}