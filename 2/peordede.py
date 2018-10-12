from flask import Flask, request, render_template, redirect
import json
import os
import random
import md5
app = Flask(__name__)


# Funcion que devuelve el link que dirige
# a una pelicula concreta TODO
def getlink(film):
    return "pelicula.html"

@app.route('/', methods = ['POST', 'GET'])
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
    sumPrice = 0
    for film in films:
        sumPrice += film['precio']
    return render_template('carrito.html', films = films, sumPrice = sumPrice)

@app.route('/contacto/')
def contacto():
    return render_template('contacto.html')

@app.route('/iniciosesion/')
def iniciosesion():
	username=request.args.get('nombre')
	if(not(username==None)):
		root='./data/usuarios/'
		listaUsuarios = [ item for item in os.listdir(root) if os.path.isdir(os.path.join(root, item)) ]
		if username in listaUsuarios:
			ruta = root+username+"/data.json"
			contrasenia = json.load(open(ruta))['password']
			print "QUE PASA PENIAA"
			if contrasenia == md5.new(request.args.get('contrasenia')).hexdigest():
				return redirect("../")
			return render_template('iniciosesion.html', usrNoexiste=None, pswEquivocada=1)
		return render_template('iniciosesion.html', usrNoexiste=1, pswEquivocada=None)

	return render_template('iniciosesion.html', usrNoexiste=None, pswEquivocada=None)

@app.route('/registro/')
def registro(methods = ['POST', 'GET']):
	username=request.args.get('usuario')
	if (not(username==None)):
		root='./data/usuarios/'
		listaUsuarios = [ item for item in os.listdir(root) if os.path.isdir(os.path.join(root, item)) ]
		if username in listaUsuarios:
			return render_template('registro.html', existe=1)
		dataR = root+username+"/data.json"
		historialR = root+username+"/historial.json"
		os.makedirs(os.path.dirname(dataR))
		#Creamos historial.json
		f = open(historialR, "w+")
		f.write("{\n\t\"peliculas\": []\n}")
		f = None

		#Creamos data.json
		with open(dataR,"w") as f:
			f.write("{\n\t\"username\": ")
			f.write("\""+username+"\",\n")
			
			f.write("\t\"name\": ")
			f.write("\""+request.args.get('nombre')+"\",\n")
			
			f.write("\t\"surname\": ")
			f.write("\""+request.args.get('apellidos')+"\",\n")

			contraseniaCifrada = md5.new(request.args.get('contrasenia')).hexdigest()
			f.write("\t\"password\": ")
			f.write("\""+contraseniaCifrada+"\",\n")
			
			f.write("\t\"email\": ")
			f.write("\""+request.args.get('correo')+"\",\n")
			
			f.write("\t\"creditcard\": ")
			f.write("\""+request.args.get('tarjeta')+"\",\n")
			
			f.write("\t\"secretno\": ")
			f.write("\""+request.args.get('secretnum')+"\",\n")
			
			f.write("\t\"saldo\": ")
			f.write(str(random.randint(1,100))+"\n}")
			return redirect("../")


	return render_template('registro.html', existe=None)

@app.route('/cuenta/')
def cuenta():
    return render_template('cuenta.html')

@app.route('/finalizarCompra/')
def finalizarCompra():
    films = json.load(open('data/catalogo.json'))['peliculas']
    sumPrice = 0
    for film in films:
        sumPrice += film['precio']
    return render_template('finalizarCompra.html', films = films, sumPrice = sumPrice)

@app.route('/historialCompras/')
def historialCompras():
	films = json.load(open('data/catalogo.json'))['peliculas']
	return render_template('historialCompras.html', films = films)

@app.route('/pelicula/<path:name>')
def pelicula(name):
	films = json.load(open('data/catalogo.json'))['peliculas']
	for film in films:
		print(name + str(film['id']))
		if int(name) == film['id']:
			return render_template('pelicula.html', film = film)

	return render_template('pelicula.html', film = None)


if __name__ == '__main__':
   app.run(debug = True)
