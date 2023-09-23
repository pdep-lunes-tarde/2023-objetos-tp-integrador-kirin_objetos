import wollok.game.*

object tpIntegrador {
	method jugar() {
		game.width(4)
		game.height(4)
		game.cellSize(100)
		game.title("2048")
		game.boardGround("fondo.png")
		
		game.addVisualCharacter(cuadrado)
		
		game.start()
	}
}

object cuadrado {
	var property position = game.at(0,0)
	method arriba() {
    	position = position.up(1) 
  	}
  	method abajo() {
    	position = position.down(1) 
  	}
  	method izquierda() {
    	position = position.left(1) 
  	}
  	method derecha() {
    	position = position.right(1) 
  	}
	method image() = "2048.png"
}