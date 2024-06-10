include "objects.iol"

interface NotificationInterface {
    OneWay:
        sendNotification(NotificationRequest),
        deleteAllNotificationsByUser(NotificationRequest)
    RequestResponse:
        notificationsHistorialByUser(NotificationRequest)(NotificationResponse)
}

interface TaskServiceInterface {
    OneWay:
        createTask(Task),
        modifyTaskUser(Task),
        modifyTaskStatus(Task),
        deleteTask(Task)
    RequestResponse:
        listAllTasks(Task)(Task),
        listTasksByUser(Task)(Task)
}

interface UserManagementInterface {
    OneWay:
        deleteUser(UserRequest)
    RequestResponse:
        registerUser(UserRequest)(UserResponse),
        authUser(UserRequest)(UserResponse),
        checkUser(UserRequest)(UserResponse)
}