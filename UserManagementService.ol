include "console.iol"
include "/protocols/http.iol"

type UserRequest: void {
    username: string,
    password: string,
    email: string
}

type UserResponse: void {
    message: string
}

interface UserManagementInterface {
    RequestResponse: registerUser(UserRequest)(UserResponse),
    authenticateUser(UserRequest)(UserResponse)
}

inputPort UserManagementPort {
    location: "socket://localhost:1235"
    protocol: http
    interfaces: UserManagementInterface
}

main {
    registerUser(req)(res) {
        // Register user logic (simplified)
        res.message = "User " + req.username + " registered successfully."
    }

    authenticateUser(req)(res) {
        // Authentication logic (simplified)
        res.message = "User " + req.username + " authenticated successfully."
    }
}
