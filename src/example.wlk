class NoHayClientes inherits Exception {

}

class SeRompio inherits Exception {

}

class NoSeLoBanca inherits Exception {

}

object pobre {

	method cuantoCafe() {
		return 10
	}

}

object rico {

	method cuantoCafe() {
		return 1500
	}

}

class Latte {

	var property leche
	var property cafe
	var property art

	method proporcion() {
		return cafe / leche
	}

}

class Maquina {

	const granosMaximos = 1000
	var usos = 243234

	method usar(granos) {
		if (granos > granosMaximos) {
			throw new NoSeLoBanca()
		}
		if (usos < 1) {
			throw new SeRompio()
		}
		usos -= 1
	}

}

class Cafeteria {

	var property situacionActual = pobre
	var property cantidadDeLeche = 100
	var property granos = 1000
	var property genteEsperando = 100
	var property maquina = new Maquina()

	method hacerCafe() {
		return new Latte(leche = self.cuantaLeche(), cafe = self.cuantoCafe(), art = self.latteArt())
	}

	method latteArt() {
		return genteEsperando < 10
	}

	method restarLoConsumido(latte) {
		granos -= latte.cafe()
		self.restarGente()
	;
		
	}

	method restarGente() {
		if (genteEsperando < 1) {
			throw new NoHayClientes()
		}
		genteEsperando -= 1
	}

	method servirCafe() {
		var latte = self.hacerCafe()
		self.restarLoConsumido(latte)
		maquina.usar(latte.cafe())
		return latte
	}

	method cuantoCafe() {
		return situacionActual.cuantoCafe()
	}

	method cuantaLeche() {
		return cantidadDeLeche
	}

}

object cafeinomano {

	method puntuar(latte) {
		// hacer esto bien
		return latte.cafe() / latte.leche() * 100
	}

}

object cafeIgualALeche {

	method proporcion() = 1

}

class Perfeccionista {

	var property escuela = cafeIgualALeche

	method cumpleLaEscuela(latte) {
		return latte.proporcion() == escuela.proporcion()
	}

	method puntuar(latte) {
		if (self.cumpleLaEscuela(latte)) return 10
		return 0
	}

}

object artista {

	method puntosPorCafe(latte) {
		if (latte.proporcion() < 1) return 5
		return 0
	}

	method puntosPorArte(latte) {
		if (latte.art()) return 5
		return 0
	}

	method puntuar(latte) {
		return self.puntosPorCafe(latte) + self.puntosPorArte(latte)
	}

}

object elQueNoSabe {

	var property amigo = artista

	method puntuar(latte) {
		return amigo.puntuar(latte) - 1
	}

}

object negativo {

	method puntuar(latte) {
		return 0
	}

}

class Jurado {

	var property criticos = []

	method puntuar(latte) {
		return criticos.sum({ critico => critico.puntuar(latte) }) / criticos.size()
	}

}

object estafador {

	method hacerCafe() {
		return new Latte(leche = 0, cafe = 0, art = false)
	}

	method servirCafe() {
		return self.hacerCafe()
	}

}

class Mezclador {

	var negocios = [ estafador, estafador ]

	method mezclarLattes(lattes) {
		var cafe = lattes.sum({ latte => latte.cafe() })
		var leche = lattes.sum({ latte => latte.leche() })
		return new Latte(leche = leche, cafe = cafe, art = false)
	}

	method hacerCafe() {
		var lattes = negocios.map({ negocio => negocio.hacerCafe() })
		return self.mezclarLattes(lattes)
	}

	method servirCafe() {
		return self.hacerCafe()
	}

}

object amargo inherits Cafeteria {

	var property clientes = [ 1, 43, 43, 42 ]

	override method cuantaLeche() {
		return 0
	}

	override method cuantoCafe() {
		return clientes.first()
	}

	override method restarGente() {
		if (clientes.size() < 1) {
			throw new NoHayClientes()
		}
		clientes.drop(1)
	}

}

