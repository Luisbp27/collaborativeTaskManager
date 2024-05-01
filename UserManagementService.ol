include "console.iol"
include "/protocols/http.iol"

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

type Users: void {
    id: int
    user: string
}

interface UserManagementInterface {
    RequestResponse:
    registerUser(UserRequest)(UserResponse),
    checkUser(UserRequest)(UserResponse),
    deleteUser(UserRequest)(UserResponse)
}

inputPort UserManagementPort {
    location: "socket://localhost:1235"
    protocol: http
    interfaces: UserManagementInterface
}

main {
    i = 0
    registerUser(req)(res) {
        // Adding user
        Users.username[i] = req.username
        Users.id[i] = req.userId
        i = i + 1

        // Send response
        res.message = "User " + req.username + " registered successfully."
    }

    checkUser(req)(res) {
        // Check if the user is in the list
        found = false
        j = 0
        while (found == false && j < i) {
            if (Users.username[j] == req.username) {
                found = true
            }
            j = j + 1
        }

        // Send response
        if (found == false) {
            res.userRegistered = false
            res.message = "User " + req.username + " is not registered."
        } else {
            res.userRegistered = true
            res.message = "User " + req.username + " is registered."
        }
    }

    deleteUser(req)(res) {
        j = req.userId

        // Delete user
        Users.username[j] = ""
        Users.id[j] = 0

        // Get the last user and move it to the deleted user position
        Users.username[j] = Users.username[i]
        Users.id[j] = Users.id[i]
        i = i - 1

        // Delete all the notifications of the deleted user
        // TODO

        // Send response
        res.message = "User " + req.username + " deleted successfully."
    }
}
