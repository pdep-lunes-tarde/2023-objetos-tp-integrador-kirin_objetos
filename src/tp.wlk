import wollok.game.*


class Numero {
	const numero
	var property position
	var movimientosFaltantes = 0
	
	method movimientosFaltantes() = movimientosFaltantes
	
	method movimientosFaltantes(nuevo_numero){
		movimientosFaltantes += nuevo_numero
	}
	
	method arriba(casilleros) {
 		position = position.up(casilleros)
 	}
  	method abajo(casilleros) {
 		position = position.down(casilleros)
 	}
  	method izquierda(casilleros) {
    	position = position.left(casilleros) 
  	}
  	method derecha(casilleros) {
    	position = position.right(casilleros)
  	}
  	
  	method positionX(){
		return self.position().x()
	}
	
	method positionY(){
		return self.position().y()
	}

	method image() = "assets/" + numero + ".png"
}

object juego {
	const property numeros = []
	var referencia
	var property intentos
			
	method iniciar() {
			
		game.width(6)
		game.height(7)
		game.cellSize(100)
		game.title("2048")
		game.boardGround("fondo.png")

		self.agregarNumero() 
		self.agregarNumero()
		
		
		
		keyboard.up().onPressDo{
			self.agregarNumero()
			self.ordenarNumeros("arriba")
			self.numeros().forEach({num => self.moverNumero(num, "arriba")})
		}
		
		keyboard.down().onPressDo{
			self.agregarNumero()
			self.ordenarNumeros("abajo")
			self.numeros().forEach({num => self.moverNumero(num, "abajo")})
		}
		keyboard.left().onPressDo{
			self.agregarNumero()
			self.ordenarNumeros("izquierda")
			self.numeros().forEach({num => self.moverNumero(num, "izquierda")})
		}
		keyboard.right().onPressDo{
			self.agregarNumero()
			self.ordenarNumeros("derecha")
			self.numeros().forEach({num => self.moverNumero(num, "derecha")})
		
		}

		
		game.start()
	}
	
	method ordenarNumeros(direccion) {
		if (direccion == "derecha") {
	 		 numeros.sortBy{ num1,num2 => num1.positionX() > num2.positionX() }
		} else if (direccion == "izquierda") {
			numeros.sortBy{ num1,num2 => num1.positionX() < num2.positionX() }
		} else if (direccion == "abajo") {
	 		numeros.sortBy{ num1,num2 => num1.positionY() < num2.positionY() }
		} else if (direccion == "arriba") {
			numeros.sortBy{ num1,num2 => num1.positionY() > num2.positionY() }
		}
	}
	
	method removeAndAdd(objeto,position){
		game.removeVisual(objeto)
		game.addVisualIn(objeto, position)
	}
	
	method agregarNumero(){
		intentos = 16
		const ejeRandom = self.eje_random()
		referencia = new Numero(numero=2,position=ejeRandom)
		numeros.add(referencia)
		game.addVisual(referencia)
	}
	
	method positionX(){
		return referencia.position().x()
	}
	
	method positionY(){
		return referencia.position().y()
	}
	
	method coordenada_a_posicion(x,y){
		return game.at(x,y)
	}
	
	method estaOcupado(x,y){
		return game.getObjectsIn(self.coordenada_a_posicion(x,y)).size() != 0
	}
	
	method moverNumero(numero, direccion){
		const x = numero.positionX()
		const y = numero.positionY()
		var casilleros
	
		if (direccion == "derecha") {
	  		casilleros = 4 - x
		} else if (direccion == "izquierda") {
	  		casilleros = x - 1
		} else if (direccion == "arriba") {
	  		casilleros = 4 - y
		} else if (direccion == "abajo") {
	  		casilleros = y - 1
		}
	
		numero.movimientosFaltantes(casilleros)
	
		if (direccion == "derecha" && x < 4) {
	  		if (!self.estaOcupado(x + 1, y) && numero.movimientosFaltantes() > 0) {
	    		numero.derecha(1)
	    		numero.movimientosFaltantes(-1)
	    		self.moverNumero(numero, direccion)
	  		}
		} else if (direccion == "izquierda" && x > 1) {
			if (!self.estaOcupado(x - 1, y) && numero.movimientosFaltantes() > 0) {
				numero.izquierda(1)
				numero.movimientosFaltantes(-1)
				self.moverNumero(numero, direccion)
			}
	  	} else if (direccion == "arriba" && y < 4) {
			if (!self.estaOcupado(x, y + 1) && numero.movimientosFaltantes() > 0) {
	  			numero.arriba(1)
	  			numero.movimientosFaltantes(-1)
	  			self.moverNumero(numero, direccion)
			}
		} else if (direccion == "abajo" && y > 1) {
	  		if (!self.estaOcupado(x, y - 1) && numero.movimientosFaltantes() > 0) {
	    		numero.abajo(1)
	    		numero.movimientosFaltantes(-1)
	    		self.moverNumero(numero, direccion)
	  		}
		}
	}
		
	method eje_random(){
		
		if (intentos == 0) {
    		console.println("No hay lugares disponibles en el tablero.")
  		}
		
		const ejeX = new Range(start = 1, end = 4).anyOne()
		const ejeY = new Range(start = 1, end = 4).anyOne()
		
		if (self.estaOcupado(ejeX,ejeY) && intentos > 0){
			intentos -= 1
			return self.eje_random()
		} else {
			return game.at(ejeX,ejeY)
		} 

	}

}
