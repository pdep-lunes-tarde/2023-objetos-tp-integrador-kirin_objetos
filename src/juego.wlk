import wollok.game.*

class Numero {
	var property numero
	var property position
  	method x() = self.position().x()
	method y() = self.position().y()
	method image() = "assets/" + numero + ".png"
	method sumarCon(unNumero){
		self.numero(unNumero.numero()*2)
	}
}

object finalizar{
	
	method reiniciar(){
		juego.numeros().forEach{numero =>
			juego.numeros().remove(numero)
			game.removeVisual(numero)
		}
		if(game.hasVisual(pantallaPerder)){
			game.removeVisual(pantallaPerder)
		}
		if(game.hasVisual(pantallaGanar)){
			game.removeVisual(pantallaGanar)
		}
		juego.configuracionInicial()
	}
	
	method tecla(){}
}

object enCurso{
	method reiniciar(){}
	method tecla(direccion){
	        var seMovio = false
			direccion.ordenarNumeros(juego.numeros())
	        juego.numeros().forEach{ num =>
	            if(juego.moverNumero(num, direccion)) {
	                seMovio = true
            	}
        	}
	        
	        if(seMovio) { 
	            juego.agregarNumero()
	            juego.movimientos(juego.movimientos()+1)
	            juego.chequearPuntaje(juego.puntajes())
	            juego.numeros().forEach { numero => juego.chequearGanador(numero) }
	            
	            if(!game.hasVisual(pantallaGanar)){
	                juego.chequearPerdedor()   
            } 
        }	
	}
	
}

object juego {
	var property estado = enCurso
	var property movimientos = 0
	var referencia
	var property puntajes = 0
	var puntajeMasAlto = 0
	const property numeros = new List()
	const tablero = [
		game.at(1,4),game.at(2,4),game.at(3,4),game.at(4,4),
		game.at(1,3),game.at(2,3),game.at(3,3),game.at(4,3),
		game.at(1,2),game.at(2,2),game.at(3,2),game.at(4,2),
		game.at(1,1),game.at(2,1),game.at(3,1),game.at(4,1)]
	const direcciones = [derecha,izquierda,arriba,abajo]
			
	method iniciar() {	
		self.configuracionBasica()
		self.configuracionInicial()
		self.configurarTeclas()
		game.start()
	}
	
	method configuracionBasica(){
		game.width(6)
		game.height(7)
		game.cellSize(100)
		game.title("2048 - Paradigmas de Programación UTN FRBA")
		game.boardGround("assets/fondo.png")
		game.addVisual(pantallaPuntaje)
		game.addVisual(pantallaMovimiento)
		game.addVisual(pantallaPuntajeMasAlto)
		
	}
	
	method configuracionInicial() {
		puntajes = 0
		movimientos = 0
		estado = enCurso
		self.agregarNumero()
		self.agregarNumero()
	}
	
	method configurarTeclas() {
		keyboard.up().onPressDo{ estado.tecla(arriba) }
		keyboard.down().onPressDo{ estado.tecla(abajo) }
		keyboard.left().onPressDo{ estado.tecla(izquierda) }
		keyboard.right().onPressDo{ estado.tecla(derecha) }
		keyboard.r().onPressDo{ estado.reiniciar() }
	}
	
	method agregarNumero(){
		if(!self.estaLleno()){
			const nuevoEje = self.ejeRandom()
			self.agregarNumeroEn(2,nuevoEje.x(),nuevoEje.y())
		}
	}
	
	method agregarNumeroEn(cual,x,y){	
		referencia = new Numero(numero=cual,position=game.at(x,y))
		numeros.add(referencia)
		game.addVisual(referencia)	
	}
	
	method ejeRandom() {
		const x = new Range(start = 1, end = 4).anyOne()
		const y = new Range(start = 1, end = 4).anyOne()
		if(!self.estaOcupado(x,y))
			return game.at(x,y)
		else
			return self.ejeRandom()	
	}
		
	method estaOcupado(x,y) = game.getObjectsIn(game.at(x,y)).size() > 0
		
	method moverNumero(numero, direccion){
	    const x = numero.x()
	    const y = numero.y()
	    const movimientosRestantes = direccion.calcularCasillerosRestantes(numero)
	
	    if (movimientosRestantes > 0) {

			const nuevoX = x + direccion.calcularIncrementoX()
	        const nuevoY = y + direccion.calcularIncrementoY()
	
	        if (!self.estaOcupado(nuevoX, nuevoY)) {
	        	
	            numero.position(game.at(nuevoX, nuevoY))
	            self.moverNumero(numero, direccion)
	            return true
	            
	        } else {
	            const numeroEnNuevaPosicion = self.getNumeroEn(nuevoX, nuevoY)
	            
	            if (numero.numero() == numeroEnNuevaPosicion.numero()) {
	            	
	                self.sumarNumeros(numero, numeroEnNuevaPosicion)
	                self.moverNumero(numero, direccion)
	                return true
	            }
	        }
		}
		return false
	}

	method sePuedeMover(numero) = direcciones.any{direccion=> self.movimientoValido(numero,direccion)}

	method movimientoValido(numero, direccion) {
	    const x = numero.x()
	    const y = numero.y()

		const movimientosRestantes = direccion.calcularCasillerosRestantes(numero)
	
	    if (movimientosRestantes == 0) {
	        return false
	    }

		const nuevoX = x + direccion.calcularIncrementoX()
	    const nuevoY = y + direccion.calcularIncrementoY()
	    
        if (self.estaOcupado(nuevoX, nuevoY)) {
            const numeroEnNuevaPosicion = self.getNumeroEn(nuevoX, nuevoY)
            return numero.numero() == numeroEnNuevaPosicion.numero()
        } else {
            return true
        }
	    
	}

	method sumarNumeros(numero1, numero2) {
		numero1.sumarCon(numero2)
    	puntajes += numero1.numero()
    	game.removeVisual(numero2)
       	self.numeros().remove(numero2)		  	
	} 

	method getNumeroEn(x, y) = game.getObjectsIn(game.at(x,y)).head()
	
	method puntajes() = puntajes
	
	method puntajeMasAlto() = puntajeMasAlto
	
	method movimientos() = movimientos	
	
	method terminar(visual){
		self.estado(finalizar)
		game.addVisual(visual)	
	}
	
	method chequearGanador(numero){
		if(numero.numero() == 2048){
			self.terminar(pantallaGanar)
		}
	}
	
	method chequearPerdedor(){
		if(self.estaLleno() and !self.numeros().any({numero=>self.sePuedeMover(numero)})){
			self.terminar(pantallaPerder)
		}
	}
	
	method chequearPuntaje(puntaje) {
		puntajeMasAlto = puntajeMasAlto.max(puntaje)		
	}
	
	method estaLleno() = tablero.all{casillero=>self.estaOcupado(casillero.x(),casillero.y())}
}

class PantallaConTexto {
	method textColor() = "766e65"
}

class PantallaFinal {
	method position() = game.at(0,0)
}

object pantallaPuntajeMasAlto inherits PantallaConTexto {
	method position() = game.at(5,6)
	method text() = juego.puntajeMasAlto().toString()
}

object pantallaPuntaje inherits PantallaConTexto {
	method position() = game.at(4,6)
	method text() = juego.puntajes().toString()
}

object pantallaMovimiento inherits PantallaConTexto {
	method position() = game.at(3,6)
	method text() = juego.movimientos().toString()
}

object pantallaPerder inherits PantallaFinal {
	method image() = "assets/perdiste.png"
}

object pantallaGanar inherits PantallaFinal {
	method image() = "assets/ganaste.png"
}

class Direccion {
	method calcularCasillerosRestantes(numero)
	method calcularIncrementoX()
	method calcularIncrementoY()
	method ordenarNumeros(numeros)
}

object izquierda inherits Direccion { 
	const limiteIzquierdo = 1
	override method calcularCasillerosRestantes(numero){
		const x = numero.x() 
		return x - limiteIzquierdo
	} 
	
	override method calcularIncrementoX(){
		return -1
	}
	override method calcularIncrementoY(){
		return 0
	}
	
	override method ordenarNumeros(numeros){
		numeros.sortBy{ num1,num2 => num1.x() < num2.x() }
	}
}

object derecha inherits Direccion { 
	const limiteDerecho = 4
	override method calcularCasillerosRestantes(numero){
		const x = numero.x() 
		return limiteDerecho - x 
	}
	
	override method calcularIncrementoX(){
		return 1
	}
	override method calcularIncrementoY(){
		return 0
	}
	override method ordenarNumeros(numeros){
		numeros.sortBy{ num1,num2 => num1.x() > num2.x() }
	}
}

object abajo inherits Direccion { 
	const limiteInferior = 1
	override method calcularCasillerosRestantes(numero){
     	const y = numero.y()
		return y - limiteInferior 
	}
	
	override method calcularIncrementoX(){
		return 0
	}
	override method calcularIncrementoY(){
		return -1
	}
	override method ordenarNumeros(numeros){
		numeros.sortBy{ num1,num2 => num1.y() < num2.y() }
	}
}

object arriba inherits Direccion { 
	const limiteSuperior = 4
	override method calcularCasillerosRestantes(numero){
     	const y = numero.y()
		return limiteSuperior - y
	}
	
	override method calcularIncrementoX(){
		return 0
	}
	override method calcularIncrementoY(){
		return 1
	}
	override method ordenarNumeros(numeros){
		numeros.sortBy{ num1,num2 => num1.y() > num2.y() }
	}
}