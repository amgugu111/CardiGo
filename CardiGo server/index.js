const app = require('express')()
const http = require('http').createServer(app)


app.get('/', (req, res) => {
    res.send("CardiGo Node Server is running. Yay!!")
})

//Socket Logic
const socketio = require('socket.io')(http)

socketio.on("connection", (userSocket) => {
    userSocket.on("send_pulse", (data) => {
        userSocket.broadcast.emit("receive_pulse", data)
    })
})

http.listen(process.env.PORT)