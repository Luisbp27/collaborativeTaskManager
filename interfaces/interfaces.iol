include "objects.iol"

interface NotificationInterface {
    RequestResponse:
        sendNotification(NotificationRequest)(NotificationResponse),
        notificationsHistorialByUser(NotificationRequest)(NotificationResponse),
        deleteAllNotificationsByUser(NotificationRequest)(NotificationResponse)
}

interface TaskServiceInterface {
    RequestResponse:
        createTask(TaskRequest)(TaskResponse),
        modifyTaskUser(TaskRequest)(TaskResponse),
        modifyTaskStatus(TaskRequest)(TaskResponse),
        deleteTask(TaskRequest)(TaskResponse),
        listAllTasks(TaskRequest)(TaskResponse),
        listTasksByUser(TaskRequest)(TaskResponse)
}

interface UserManagementInterface {
    OneWay:
        registerUser(User),
    RequestResponse:
        authUser(UserRequest)(UserResponse),
        checkUser(UserRequest)(UserResponse),
        deleteUser(UserRequest)(UserResponse)
}