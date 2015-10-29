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

    this.socket.on("r", function(name,room,skin) {
        self.joinRoom(name,room,skin)
    })


    this.socket.on('disconnect', function(){
        console.log( self.name + " disconnect" )
        console.log( self.room + "room")

        // console.log(self.game.rooms)
        self.socket.broadcast.to(self.room).emit("q", self.id )
            
            if (self.game.rooms[self.room] !== undefined) {

                var aux = self.game.rooms[self.room].players

                console.log(self.game.rooms[self.room].players)

                for(var i = aux.length - 1; i >= 0; i--) {
                    if(aux[i].id === self.id) {
                        console.log
                        aux.splice(i, 1)
                    }
            }

            self.game.rooms[self.room].players = aux
            console.log(self.game.rooms[self.room].players) 
                
            }

               
            
  
    });
    
}



Player.prototype.joinRoom = function(name,skin) {
    
    this.name = name
    this.skin = skin

    //console.log("dei join")

   
    //console.log("Salas : " + this.game.rooms.length)
    for( var i = 0 ; i < this.game.rooms.length ; i++) {    
        console.log("Sala " + i)
        // console.log("maxLength " + this.game.rooms[i].maxLength) 
        console.log("players " + this.game.rooms[i].players)
        if((this.game.rooms[i].players.length < this.game.rooms[i].maxLength)) {
            //console.log("Entrei na sala" + i)

            if (this.game.rooms[i].players.length > 0) {
                var aux = this.game.rooms[i].players
                var last = aux[this.game.rooms[i].players.length - 1]
                this.id = last.id + 1
                console.log("Ja tinha alguem " + this.name + " " + this.id)   
            } 
            else {
                this.id = 0
                console.log("Nao tinha ninguem " + this.name + " " + this.id)
            }

            this.room = i
            break 
            
        }
    }

    if (this.id === 9999999) {
        console.log("criei nova sala " + this.game.rooms.length)
        this.room = this.game.rooms.length
        this.game.rooms.push(new Room())
        // console.log(this.game.rooms)
        // console.log(this.game.rooms.length)
        this.id = 0    
    } 

    
    var teste = {name : this.name , id : this.id, skin: this.skin}
    this.socket.emit("a", this.game.rooms[this.room].players, this.room, this.game.rooms[this.room].floor)
    this.socket.broadcast.to(this.room).emit("j" , teste)

    this.game.rooms[this.room].players.push(teste)
    this.socket.join(this.room)
    console.log( this.name + " Entrou na sala " + this.room)

    //console.log(this.game.rooms)

}


function Room() {
    
    this.players = new Array()
    //this.floor = Math.floor( Math.random() * 1 )
    this.floor = 0
    this.maxLength = 100
    this.started = false

    console.log( "andar " + this.floor )

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
