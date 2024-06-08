// Notification Service

type NotificationRequest: void {
    userId: string
    message: string
}

type NotificationResponse: void {
    status: string
}

type Notification: void {
    userId: string
    message: string
}

type Notifications: void {
    notification*: Notification
}

// Task Service

type TaskRequest: void {
    id : int
    title: string
    description: string
    dueDate: string
    assignedTo: string
    status: string
}

type TaskResponse: void {
    message: string
}

type Task: void {
    id: int
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
    userId: int
    username: string
    password: string
    email: string
}

type UserResponse: void {
    userRegistered : bool
    message: string
}

type User: void {
    id: int
    username: string
    password: string
    email: string
}

type Users: void {
    users*: User
}