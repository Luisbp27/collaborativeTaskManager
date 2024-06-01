interface UserManagementInterface {
    RequestResponse:
    registerUser(UserRequest)(UserResponse),
    authUser(UserRequest)(UserResponse),
    deleteUser(UserRequest)(UserResponse)
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

interface NotificationInterface {
    RequestResponse:
    sendNotification(NotificationRequest)(NotificationResponse),
    notificationsHistorialByUser(NotificationRequest)(NotificationResponse),
    deleteAllNotificationsByUser(NotificationRequest)(NotificationResponse)
}