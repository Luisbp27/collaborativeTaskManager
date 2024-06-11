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
                global.notifications.userId[global.not_iter] = req.userId
                global.notifications.message[global.not_iter] = req.message
                println@Console("Notification " + global.not_iter + ": " + req.message)()

                global.not_iter++
            }
        }

        [notificationsHistorialByUser(req)] {
            synchronized( token ) {
                println@Console("Showing notifications for user " + req.name + "\n")()

                for (j = 0, j < global.not_iter, j++) {
                    if (global.notifications.userId[j] == req.id) {
                        println@Console("Notification Nº" + j + ": " + global.notifications.message[j])()
                    }
                }
            }
        }

        [deleteAllNotificationsByUser(req)] {
            synchronized( token ) {
                for (j = 0, j < global.not_iter, j++) {
                    if (global.notifications.userId[j] == req.id) {
                        global.notifications.userId[j] = ""
                        global.notifications.message[j] = ""
                    }
                }
            }
        }
    }
}