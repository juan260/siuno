from flask import Flask, request, render_template
import json
app = Flask(__name__)


# Funcion que devuelve el link que dirige
# a una pelicula concreta TODO
def getlink(film):
    return "pelicula.html"

@app.route('/')
def index():
	films = json.load(open('data/catalogo.json'))['peliculas']
	genres = []
	for film in films:
		if film['genero'] not in genres:
			genres.append(film['genero'])
	genres.sort()
	genre=request.args.get('filters')
	if(not(genre==None or genre=='-')):
		genderedFilms = []
		for film in films:
			if film['genero']==genre:
				genderedFilms.append(film)
		films=genderedFilms				

	return render_template('index.html', films = films, genres = genres)

@app.route('/carrito/')
def carrito():
	films = json.load(open('data/catalogo.json'))['peliculas']
	return render_template('carrito.html', films = films)

@app.route('/contacto/')
def contacto():
    return render_template('contacto.html')

@app.route('/iniciosesion/')
def iniciosesion():
    return render_template('iniciosesion.html')

@app.route('/registro/')
def registro():
    return render_template('registro.html')

@app.route('/cuenta/')
def cuenta():
    return render_template('cuenta.html')

@app.route('/finalizarCompra/')
def finalizarCompra():
	films = json.load(open('data/catalogo.json'))['peliculas']
	return render_template('finalizarCompra.html', films = films)

@app.route('/historialCompras/')
def historialCompras():
	films = json.load(open('data/catalogo.json'))['peliculas']
	return render_template('historialCompras.html', films = films)

@app.route('/pelicula/<path:name>')
def pelicula(name):
	films = json.load(open('data/catalogo.json'))['peliculas']
	for film in films:
		if name == film['url']:
			return render_template('pelicula.html', film = film)

	return render_template('pelicula.html', film = None)


if __name__ == '__main__':
   app.run(debug = True)
