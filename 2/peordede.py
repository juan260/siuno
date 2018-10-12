from flask import Flask, request, render_template, redirect, session
import json
import os
import random
import md5
app = Flask(__name__)

app.secret_key = 'teamoluis'

# Funcion que devuelve el link que dirige
# a una pelicula concreta TODO
def getlink(film):
    return "pelicula.html"

@app.route('/', methods = ['POST', 'GET'])
def index(methods = ['POST', 'GET']):
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
	if('username' in session):
		return render_template('index.html', films = films, genres = genres, log = session['username'])
	else:
		return render_template('index.html', films = films, genres = genres, log = None)

@app.route('/carrito/')
def carrito():
  films = json.load(open('data/catalogo.json'))['peliculas']
  sumPrice = 0
  for film in films:
    sumPrice += film['precio']
  if('username' in session):
		return render_template('carrito.html', films = films, sumPrice = sumPrice, log = session['username'])
  else: 
		return render_template('carrito.html', films = films, sumPrice = sumPrice,log = None)
@app.route('/contacto/')
def contacto():
	if('username' in session):
		return render_template('contacto.html', log = session['username'])
	else:
		return render_template('contacto.html', log = None)

@app.route('/iniciosesion/', methods = ['POST', 'GET'])
def iniciosesion(methods = ['POST', 'GET']):
	
	if(request.method=='POST'):
		username=request.form.get('nombre')
		if(username!=None):
			root='./data/usuarios/'
			listaUsuarios = [ item for item in os.listdir(root) if os.path.isdir(os.path.join(root, item)) ]
			if username in listaUsuarios:
				ruta = root+username+"/data.json"
				contrasenia = json.load(open(ruta))['password']
				if contrasenia == md5.new(request.form.get('contrasenia')).hexdigest():
					session['username']=username
					return redirect("../")
				return render_template('iniciosesion.html', usrNoexiste=None, pswEquivocada=1)
			return render_template('iniciosesion.html', usrNoexiste=1, pswEquivocada=None)

		return render_template('iniciosesion.html', usrNoexiste=None, pswEquivocada=None)
	else:
		return render_template('iniciosesion.html', usrNoexiste=None, pswEquivocada=None)

@app.route('/registro/', methods = ['POST', 'GET'])
def registro(methods = ['POST', 'GET']):
	if(request.method=='POST'):
		username=request.form.get('usuario')
		if (username!=None):
			root='./data/usuarios/'
			listaUsuarios = [ item for item in os.listdir(root) if os.path.isdir(os.path.join(root, item)) ]
			if username in listaUsuarios:
				print("Already existing user")
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
				f.write("\""+request.form.get('nombre')+"\",\n")
				
				f.write("\t\"surname\": ")
				f.write("\""+request.form.get('apellidos')+"\",\n")

				contraseniaCifrada = md5.new(request.form.get('contrasenia')).hexdigest()
				f.write("\t\"password\": ")
				f.write("\""+contraseniaCifrada+"\",\n")
				
				f.write("\t\"email\": ")
				f.write("\""+request.form.get('correo')+"\",\n")
				
				f.write("\t\"creditcard\": ")
				f.write("\""+request.form.get('tarjeta')+"\",\n")
				
				f.write("\t\"secretno\": ")
				f.write("\""+request.form.get('secretnum')+"\",\n")
				
				f.write("\t\"saldo\": ")
				f.write(str(random.randint(1,100))+"\n}")
				session['username']=username
				print("SI ERA POST4")
				return redirect("../")

		
		return render_template('registro.html', existe=None)

	else:
		return render_template('registro.html', existe=None)

@app.route('/cuenta/')
def cuenta():
  if('username' in session):
    root='./data/usuarios/'
    ruta = root+session['username']+"/data.json"
    datosUsuario = json.load(open(ruta))
    return render_template('cuenta.html',log = datosUsuario)
  else:
		return render_template('cuenta.html',log = None)

@app.route('/finalizarCompra/')
def finalizarCompra():
	films = json.load(open('data/catalogo.json'))['peliculas']
	sumPrice = 0
	for film in films:
		sumPrice += film['precio']
	if('username' in session):
		return render_template('finalizarCompra.html', films = films, sumPrice = sumPrice, log = session['username'])
	else: 
		return render_template('finalizarCompra.html', films = films, sumPrice = sumPrice, log = None)

@app.route('/historialCompras/')
def historialCompras():
  films = json.load(open('data/catalogo.json'))['peliculas']
  if('username' in session):
    root='./data/usuarios/'
    ruta = root+session['username']+"/historial.json"
    historialUsuario = json.load(open(ruta))['peliculas']
    print(historialUsuario)
    return render_template('historialCompras.html', films = historialUsuario, log = session['username'])
  else:
		return render_template('historialCompras.html', films = None, log = None)

@app.route('/pelicula/<path:name>')
def pelicula(name):
	films = json.load(open('data/catalogo.json'))['peliculas']
	for film in films:
		print(name + str(film['id']))
		if int(name) == film['id']:
			if('username' in session):
				return render_template('pelicula.html', film = film, log = session['username'])
			else:
				return render_template('pelicula.html', film = film, log = None)
	if('username' in session):
		return render_template('pelicula.html', film = None, log = session['username'])
	else:
		return render_template('pelicula.html', film = None, log = None)

@app.route('/logout/')
def logout():
	session.pop('username', None)
	return redirect("../")


if __name__ == '__main__':
   app.run(debug = True)
