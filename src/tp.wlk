import wollok.game.*

class Numero {
	var property numero
	var property position
	var movimientosFaltantes = 0
	var property fusionado = false
	
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
		    		numero.fusionado(false)
		    		self.moverNumero(numero, direccion)
		  		} else {
		  			const numero_a_la_derecha = self.getNumeroEn(x+1,y)
		  			if (numero.numero() == numero_a_la_derecha.numero() && !numero.fusionado() && !numero_a_la_derecha.fusionado()){
		  				self.fusionarNumeros(numero,numero_a_la_derecha)
		  				numero.fusionado(true)
		  				numero_a_la_derecha.fusionado(true)
		  				self.moverNumero(numero, direccion)
		  			} else {
		  				numero.movimientosFaltantes(0)
		  			}
		  		}
		  		
			} else if (direccion == "izquierda" && x > 1) {
				if (!self.estaOcupado(x - 1, y)) {
					numero.izquierda(1)
					numero.movimientosFaltantes(-1)
					numero.fusionado(false)
					self.moverNumero(numero, direccion)
				} else {
					const numero_a_la_izquierda = self.getNumeroEn(x-1,y)
		  			if (numero.numero() == numero_a_la_izquierda.numero() &&  !numero.fusionado() && !numero_a_la_izquierda.fusionado()){
		  				self.fusionarNumeros(numero,numero_a_la_izquierda)
		  				numero.fusionado(true)
		  				numero_a_la_izquierda.fusionado(true)
		  				self.moverNumero(numero, direccion)
		  			} else {
		  				numero.movimientosFaltantes(0)
		  			}
		  		}
		  		
	  		} else if (direccion == "arriba" && y < 4) {
				if (!self.estaOcupado(x, y + 1) ) {
		  			numero.arriba(1)
		  			numero.movimientosFaltantes(-1)
		  			numero.fusionado(false)
		  			self.moverNumero(numero, direccion)
				} else {
					const numero_arriba = self.getNumeroEn(x,y+1)
		  			if (numero.numero() == numero_arriba.numero() && !numero.fusionado() && !numero_arriba.fusionado()) {
		  				self.fusionarNumeros(numero,numero_arriba)
		  				numero.fusionado(true)
		  				numero_arriba.fusionado(true)
		  				self.moverNumero(numero, direccion)
		  			} else {
		  				numero.movimientosFaltantes(0)
		  			}
		  		}
			} else if (direccion == "abajo" && y > 1) {
		  		if (!self.estaOcupado(x, y - 1)) {
		    		numero.abajo(1)
		    		numero.movimientosFaltantes(-1)
		    		numero.fusionado(false)
		    		self.moverNumero(numero, direccion)
		  		}  else {
		  			const numero_abajo = self.getNumeroEn(x,y-1)
		  			if (numero.numero() == self.getNumeroEn(x,y-1).numero() && !numero.fusionado() && !numero_abajo.fusionado()){
		  				self.fusionarNumeros(numero,numero_abajo)
		  				numero.fusionado(true)
		  				numero_abajo.fusionado(true)
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
	


