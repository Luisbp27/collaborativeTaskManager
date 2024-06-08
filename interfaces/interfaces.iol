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
    RequestResponse:
        registerUser(UserRequest)(UserResponse),
        authUser(UserRequest)(UserResponse),
        checkUser(UserRequest)(UserResponse),
        deleteUser(UserRequest)(UserResponse)
}