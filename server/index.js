const express = require("express");
var http = require("http");
const app = express();
const port = process.env.PORT || 3000
var server = http.createServer(app);
const mongoose = require("mongoose");

var io = require("socket.io")(server);

//middleware
app.use(express.json())

//connect to mongodb
const DB = "mongodb+srv://aniket:aniket%40123@skribby.xdp1p2e.mongodb.net/skribby?retryWrites=true&w=majority";

mongoose.connect(DB).then(() => {
    console.log('Connection Succesful!');
}).catch((e) => {
    console.log(e);
})

io.on('connection', (socket) => {
    console.log('connected');
    socket.on('create-game', async({nickname, name, occupancy, maxRounds}) => {
        try {

        } catch(err) {
            
        }
    })
})

server.listen(port, "0.0.0.0", () => {
    console.log('Server started and running on port ' + port);
})