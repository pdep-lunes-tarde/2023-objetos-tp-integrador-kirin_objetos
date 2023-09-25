import wollok.game.*

class Numero {
	const ejeX
	const ejeY
	const numero
	var property position = game.at(ejeX,ejeY)
	
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
	method image() = "assets/" + numero + ".png"
}

object juego {
	method iniciar() {
		game.width(4)
		game.height(4)
		game.cellSize(100)
		game.title("2048")
		game.boardGround("fondo.png")
		
		game.addVisualCharacter(new Numero(numero=2,ejeX=self.randomX(),ejeY=self.randomY()))
		game.addVisualCharacter(new Numero(numero=2,ejeX=self.randomX(),ejeY=self.randomY()))
		
		game.start()
	}
	
	method randomX(){
		return new Range(start = 0, end = 3).anyOne()

	}
	method randomY(){
		return new Range(start = 0, end = 3).anyOne()

	}
}

//object numero2 {
//	var ejeX = new Range(start = 0, end = 3).anyOne()
//	var ejeY = new Range(start = 0, end = 3).anyOne()
//	var property position = game.at(ejeX,ejeY)
//	var numero
//	method arriba() {
//    	position = position.up(1) 
//  	}
//  	method abajo() {
//    	position = position.down(1) 
//  	}
//  	method izquierda() {
//    	position = position.left(1) 
//  	}
//  	method derecha() {
//    	position = position.right(1) 
//  	}
//	method image() = "assets/" + numero + ".png"
//}