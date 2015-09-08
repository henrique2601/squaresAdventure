var app = require('http').createServer()

app.listen(3001)

function Player(socket) {
    var self = this
    this.socket = socket
    this.name = ""
    this.game = {}
    this.room = ""
    this.id = 9999999

    this.socket.on("u", function(room, x, y , vx , vy , rotation , vrotation) {
        self.game.update( self.socket ,self.id , room , x, y , vx , vy , rotation , vrotation)
    })

     this.socket.on("win", function(room) {
         console.log(self.name + "win")
         self.game.win( self.socket ,self.id , room )
     })

    this.socket.on("r", function(name,room) {
        self.joinRoom(name,room)
    })


    this.socket.on('disconnect', function(){
            console.log( self.name + " disconnect" )
            
            self.socket.broadcast.to(self.room).emit("q", self.id )
            var aux = self.game.rooms[self.room]

            console.log(self.game.rooms[self.room])

            for(var i = aux.length - 1; i >= 0; i--) {
                if(aux[i].id === self.id) {
                    aux.splice(i, 1)
                    console.log(i)
                }
            }

            self.game.rooms[self.room] = aux
            console.log(self.game.rooms[self.room])

    });
    
}



Player.prototype.joinRoom = function(name,room) {
    this.name = name
    this.room = room
    this.socket.join(this.room)

    if (this.game.rooms[this.room] === undefined) {
        this.game.rooms[this.room] = new Array()
        this.id = 0
    } 
    
    else if (this.game.rooms[this.room].length == 0) {
        this.id = 0
    } 

    else {
        var aux = this.game.rooms[this.room]
        var last = aux[this.game.rooms[this.room].length - 1]
        this.id = last.id + 1
    }
    
    var teste = {name : this.name , id : this.id}
    this.socket.emit("a", this.game.rooms[this.room])
    this.socket.broadcast.to(this.room).emit("j" , teste)

    this.game.rooms[this.room].push(teste)

    //console.log(this.game.rooms[this.room])

    
 
}





function Game() {
    this.io = require('socket.io')(app)
 
    this.players = []
    this.rooms = []

    console.log(this.players.length)

    this.started = false
    this.addHandlers()
}

Game.prototype.addHandlers = function() {
    var game = this

    this.io.sockets.on("connection", function(socket) {
        game.addPlayer(new Player(socket))
        socket.emit("d")

        

        

    })
}

Game.prototype.addPlayer = function(player) {
    
    
    player.game = this
    

}



Game.prototype.update = function(socket, id, room, x, y , vx , vy , rotation , vrotation) {

    
        socket.broadcast.to(room).emit("u", id , x, y , vx , vy , rotation , vrotation )
    
    

}


Game.prototype.win = function(socket, id, room) {

    
        socket.broadcast.to(room).emit("win", id)
    
    

}



Game.prototype.startGame = function() {
    this.player1.socket.emit("startGame")
    this.player2.socket.emit("startGame")
}


var game = new Game()