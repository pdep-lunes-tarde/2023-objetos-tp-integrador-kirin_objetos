import wollok.game.*

class Numero {
	var property numero
	var property position
	var movimientosFaltantes = 0
	
	method numero() = numero
	
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
	var property puntaje = 0
	var property intentos = 100
			
	method iniciar() {	
		game.width(6)
		game.height(7)
		game.cellSize(100)
		game.title("2048")
		game.boardGround("fondo.png")
		
		/*	Bugs detectados:
		 * 
		 * 	Si se llena el tablero, el juego deja de funcionar porque se agotan los "intentos"
		 * 	que agregarNumero hace cuando añade numeros nuevos. Hay que buscar otra forma de
		 *  poner esa logica para que detecte sin entrar en un bucle infinito que no hay mas 
		 *  espacio en el tablero. Esto es un bug porque puede ser que el tablero esté lleno
		 *  y con un movimiento a cualquier direccion se abran nuevos espacios, entonces deberia
		 * 	dejarlo abierto hasta que ya no haya mas posibilidades de juntar nuevos bloques en
		 * 	ninguna dirección, y ahi es cuando deberia salir la pantalla del game over.
		 * 
		 */
		 
		 /*	Falta por hacer:
		  * 
		  * Implementar puntajes en pantalla (ya esta la variable con el puntaje)
		  * Implementar boton de reiniciar juego
		  * Implementar cantidad de movimientos? 
		  * Implementar pantalla de ganador
		  * Agregar musica?
		  * 
		  */

		self.agregarNumero()
		self.agregarNumero()
		
		keyboard.up().onPressDo{
			self.ordenarNumeros("arriba")
			self.numeros().forEach({num => self.moverNumero(num, "arriba")})
			self.agregarNumero()
		}
		
		keyboard.down().onPressDo{
			self.ordenarNumeros("abajo")
			self.numeros().forEach({num => self.moverNumero(num, "abajo")})
			self.agregarNumero()
		}
		keyboard.left().onPressDo{
			self.ordenarNumeros("izquierda")
			self.numeros().forEach({num => self.moverNumero(num, "izquierda")})
			self.agregarNumero()
		}
		keyboard.right().onPressDo{
			self.ordenarNumeros("derecha")
			self.numeros().forEach({num => self.moverNumero(num, "derecha")})
			self.agregarNumero()
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
	
	method agregarNumero(){
		const ejeRandom = self.eje_random()
		if (intentos > 0){
			if (!self.estaOcupado(ejeRandom)){
				referencia = new Numero(numero=2,position=ejeRandom)
				numeros.add(referencia)
				game.addVisual(referencia)
				intentos = 100
			} else {
				intentos -= 1
				self.agregarNumero()
			} 
		}
	}
	
	// Solo para troubleshooting
	method agregarNumeroEn(cual,x,y){		
		referencia = new Numero(numero=cual,position=game.at(x,y))
		numeros.add(referencia)
		game.addVisual(referencia)	
	}
	
	method eje_random() = game.at(new Range(start = 1, end = 4).anyOne(),new Range(start = 1, end = 4).anyOne())
	
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
		return game.getObjectsIn(self.coordenada_a_posicion(x,y)).size() > 0
	}
	
	method estaOcupado(posicion){
		return game.getObjectsIn(posicion).size() > 0
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
		
		if(numero.movimientosFaltantes() > 0) {
			if (direccion == "derecha" && x < 4) {
		  		if (!self.estaOcupado(x + 1, y)) {
		    		numero.derecha(1)
		    		numero.movimientosFaltantes(-1)
		    		self.moverNumero(numero, direccion)
		  		} else {
		  			const numero_a_la_derecha = self.getNumeroEn(x+1,y)
		  			if (numero.numero() == numero_a_la_derecha.numero()){
		  				self.fusionarNumeros(numero,numero_a_la_derecha)
		  				self.moverNumero(numero, direccion)
		  			} else {
		  				numero.movimientosFaltantes(0)
		  			}
		  		}
		  		
			} else if (direccion == "izquierda" && x > 1) {
				if (!self.estaOcupado(x - 1, y)) {
					numero.izquierda(1)
					numero.movimientosFaltantes(-1)
					self.moverNumero(numero, direccion)
				} else {
					const numero_a_la_izquierda = self.getNumeroEn(x-1,y)
		  			if (numero.numero() == numero_a_la_izquierda.numero()){
		  				self.fusionarNumeros(numero,numero_a_la_izquierda)
		  				self.moverNumero(numero, direccion)
		  			} else {
		  				numero.movimientosFaltantes(0)
		  			}
		  		}
		  		
	  		} else if (direccion == "arriba" && y < 4) {
				if (!self.estaOcupado(x, y + 1) ) {
		  			numero.arriba(1)
		  			numero.movimientosFaltantes(-1)
		  			self.moverNumero(numero, direccion)
				} else {
					const numero_arriba = self.getNumeroEn(x,y+1)
		  			if (numero.numero() == numero_arriba.numero()) {
		  				self.fusionarNumeros(numero,numero_arriba)
		  				self.moverNumero(numero, direccion)
		  			} else {
		  				numero.movimientosFaltantes(0)
		  			}
		  		}
			} else if (direccion == "abajo" && y > 1) {
		  		if (!self.estaOcupado(x, y - 1)) {
		    		numero.abajo(1)
		    		numero.movimientosFaltantes(-1)
		    		self.moverNumero(numero, direccion)
		  		}  else {
		  			const numero_abajo = self.getNumeroEn(x,y-1)
		  			if (numero.numero() == self.getNumeroEn(x,y-1).numero()){
		  				self.fusionarNumeros(numero,numero_abajo)
		  				self.moverNumero(numero, direccion)
		  			} else {
		  				numero.movimientosFaltantes(0)
		  			}
		  		}
			}
		}

	}
	
	method fusionarNumeros(numero1, numero2) {
	    if (numero1.numero() == numero2.numero()) {
	        numero1.numero(numero1.numero()*2)
	        puntaje += numero1.numero()
	        numero1.image()
	        game.removeVisual(numero2)
	        self.numeros().remove(numero2)
	    } 
	}

	method getNumeroEn(x, y) {
		return game.getObjectsIn(game.at(x,y)).head()
	}
}