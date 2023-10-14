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
  	
  	method x() = self.position().x()
	
	method y() = self.position().y()

	method image() = "assets/" + numero + ".png"
}