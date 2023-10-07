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
	var puntajes = 0
	var movimientos = 0
			
	method iniciar() {	
		
		self.hacerConfiguracionInicial()
		self.configurarTeclas()
		game.start()
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
		  * Implementar puntajes en pantalla ✔
		  * Implementar boton de reiniciar juego
		  * Implementar cantidad de movimientos ✔
		  * Implementar pantalla de ganador
		  * Agregar musica?
		  * 
		  */	
	}
	
	method hacerConfiguracionInicial() {
		game.width(6)
		game.height(7)
		game.cellSize(100)
		game.title("2048")
		game.boardGround("assets/fondo.png")
		game.addVisual(puntaje)
		game.addVisual(movimiento)
		
		puntajes = 0
		movimientos = 0
			
		self.agregarNumero()
		self.agregarNumero()
	}
	
	method configurarTeclas() {
		keyboard.up().onPressDo{
			self.ordenarNumeros("arriba")
			self.numeros().forEach({num => self.moverNumero(num, "arriba")})
			self.agregarNumero()
			movimientos += 1
		}
		
		keyboard.down().onPressDo{
			self.ordenarNumeros("abajo")
			self.numeros().forEach({num => self.moverNumero(num, "abajo")})
			self.agregarNumero()
			movimientos += 1
		}
		keyboard.left().onPressDo{
			self.ordenarNumeros("izquierda")
			self.numeros().forEach({num => self.moverNumero(num, "izquierda")})
			self.agregarNumero()
			movimientos += 1
		}
		keyboard.right().onPressDo{
			self.ordenarNumeros("derecha")
			self.numeros().forEach({num => self.moverNumero(num, "derecha")})
			self.agregarNumero()
			movimientos += 1
		}
		keyboard.r().onPressDo{
			//game.clear()
			//self.iniciar()
		}
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
		
		if(!estado.estadoTodoOcupado()){
				if (!self.estaOcupado(ejeRandom)){
					referencia = new Numero(numero=2,position=ejeRandom)
					numeros.add(referencia)
					game.addVisual(referencia)
				} else {
					self.agregarNumero()
				} 
			} else {
				console.println("está todo ocupado.")
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
		if(!estado.estadoTodoOcupado()){
			if (numero1.numero() == numero2.numero()) {
	        numero1.numero(numero1.numero()*2)
	        puntajes += numero1.numero()
	        numero1.image()
	        game.removeVisual(numero2)
	        self.numeros().remove(numero2)
	    	} 
		}
	}

	method getNumeroEn(x, y) {
		return game.getObjectsIn(game.at(x,y)).head()
	}
	
	method puntajes(){
		return puntajes
	}
	
	method movimientos(){
		return movimientos
	}
	
}

object puntaje {
	method position() = game.at(2,5)
	method image() = "assets/label.png"
	method text() = "Puntajes " + juego.puntajes()
	method textColor() = "FFFFFF"
}

object movimiento {
	method position() = game.at(4,5)
	method image() = "assets/label.png"
	method text() = "Movimientos " + juego.movimientos()
	method textColor() = "FFFFFF"
}

object estado { // NO FUNCIONA
	const estadoLista = [
		juego.estaOcupado(1,1),
		juego.estaOcupado(1,2),
		juego.estaOcupado(1,3),
		juego.estaOcupado(1,4),
		
		juego.estaOcupado(2,1),
		juego.estaOcupado(2,2),
		juego.estaOcupado(2,3),
		juego.estaOcupado(2,4),
		
		juego.estaOcupado(3,1),
		juego.estaOcupado(3,2),
		juego.estaOcupado(3,3),
		juego.estaOcupado(3,4),
		
		juego.estaOcupado(4,1),
		juego.estaOcupado(4,2),
		juego.estaOcupado(4,3),
		juego.estaOcupado(4,4)
	]
	method estado(){
		return estadoLista
	}  
	
	method estadoTodoOcupado(){
		return estadoLista.all({ elemento => elemento == true })
	}

}