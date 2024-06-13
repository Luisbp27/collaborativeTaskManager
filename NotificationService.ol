include "console.iol"
include "/protocols/http.iol"
include "interfaces/interfaces.iol"
include "interfaces/objects.iol"

service NotificationService() {

    execution: concurrent

    inputPort NotificationPort {
        location: "socket://localhost:1236"
        protocol: http
        interfaces: NotificationInterface
    }

    init {
        global.not_iter = 0
        global.notifications = Notifications
    }

    main {
        [sendNotification(req)] {
            synchronized( token ) {
                // Save notification
                global.notifications.userId[global.not_iter] = req.userId
                global.notifications.message[global.not_iter] = req.message

                // Print notification
                println@Console("Notification " + global.not_iter + ": " + req.message)()

                // Increment notification counter
                global.not_iter++
            }
        }

        [notificationsHistorialByUser(req)(notifications) {
            synchronized( token ) {
                // Print all notifications for the user by their id
                notifications = ""
                for (j = 0, j < global.not_iter, j++) {
                    if (global.notifications.userId[j] == req.userId) {
                        notifications += j + "   " + global.notifications.message[j] + "\n"
                    }
                }
            }
        }]
    }
}