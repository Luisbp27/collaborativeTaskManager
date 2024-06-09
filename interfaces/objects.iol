// Notification Service

type NotificationRequest: void {
    userId: string
    message: string
}

type Notification: void {
    userId: string
    message: string
}

type Notifications: void {
    notification*: Notification
}

// Task Service

type Task: void {
    id : int
    title: string
    description: string
    dueDate: string
    assignedTo: string
    status: string
}

type Tasks: void {
    task*: Task
}

// User Management Service

type UserRequest: void {
    id: int
    name: string
    password: string
    email: string
}

type UserResponse: void {
    userRegistered : bool
}

type Users: void {
    users*: UserRequest
}