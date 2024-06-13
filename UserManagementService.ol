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
        global.users = Users
    }

    main {
        [registerUser(req)(res) {
            synchronized( token ) {
                // Adding user to the list
                global.users.id[global.user_iter] = global.user_iter
                global.users.name[global.user_iter] = req.name
                global.users.password[global.user_iter] = req.password
                global.users.email[global.user_iter] = req.email

                // Send notification
                notReq.userId = global.users.id[global.user_iter]
                notReq.message = "User " + global.users.name[global.user_iter] + " with id: " + global.users.id[global.user_iter] + " registered"
                sendNotification@NotificationManager(notReq)

                // Send response and increment user_iter
                res.id = global.users.id[global.user_iter]
                global.user_iter++
            }
        }]

        [authUser(req)(res) {
            synchronized( token ) {
                // Check if the user is in the list
                found = false
                id = 0

                while (found == false && id < global.user_iter) {
                    if (global.users.id[id] == req.id && global.users.name[id] == req.name && global.users.password[id] == req.password) {
                        found = true
                    }
                    id++
                }

                // Send response
                res.userRegistered = found
            }
        }]

        [checkUser(req)(res) {
            synchronized( token ) {
                // Check if the user is in the list
                found = false
                id = 0

                while (found == false && id < global.user_iter) {
                    if (global.users.id[id] == req.id && global.users.name[id] == req.name) {
                        found = true
                    }
                    id++
                }

                // Send response
                res.userRegistered = found
            }
        }]

        [deleteUser(req)] {
            synchronized( token ) {
                id = req.id

                // Delete user
                users.name[id] = ""
                users.id[id] = -1

                // Get the last user and move it to the deleted user position
                users.name[id] = users.name[global.user_iter]
                users.id[id] = users.id[global.user_iter]

                // Send notification
                notReq.userId = id
                notReq.message = "User " + users[id].name + " deleted"

                // Delete all the notifications of the deleted user
                sendNotification@NotificationManager(notReq)

                global.user_iter--
            }
        }
    }
}