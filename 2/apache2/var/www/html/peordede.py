from flask import Flask, request, render_template, redirect, session,url_for
import json
import os
import random
import md5
import sys
import datetime
app = Flask(__name__)
sys.path.append('~/apache2/var/www/html/')
app.secret_key = 'teamoluis'
app.root_path=os.path.dirname(os.path.abspath(__file__))

@app.route('/', methods = ['POST', 'GET'])
def index(methods = ['POST', 'GET']):
  #films = json.load(open(os.path.join(app.root_path,'data/catalogo.json')))['peliculas']
  #films = json.load(join(dirname(realpath(__file__)), 'data/catalogo.json'))
  #films=json.load(open('/data/catalogo.json'))
  try:
    jsonFile = open(app.root_path + '/data/catalogo.json')
  except IOError:
    return "No se pudieron cargar las peliculas"
  films=json.load(jsonFile)['peliculas']
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

@app.route('/carrito/', methods=['GET','POST'])
def carrito(methods=['GET','POST']):
  try:
    jsonFile = open(app.root_path + '/data/catalogo.json')
  except IOError:
    return "No se pudieron cargar las peliculas"
  films_cat=json.load(jsonFile)['peliculas']
  try:
    carrito = session['carrito']
  except KeyError:
    carrito=[]
    sumPrice=0
  else:
    sumPrice = 0
    carrito = [x for x in carrito if x[0] in films_cat]
    for film in carrito:
      sumPrice += (film[0]['precio']*film[1])
  if(request.method=='POST'):
    del_film_id=request.form.get('id')
    carrito = [x for x in carrito if x[0]['id'] != int(del_film_id)]
    session['carrito']=carrito
    return redirect("./carrito/")


  if('username' in session):
    return render_template('carrito.html', films = carrito, sumPrice = sumPrice, log = session['username'])
  else:
    return render_template('carrito.html', films = carrito, sumPrice = sumPrice,log = None)

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
      root=app.root_path + '/data/usuarios/'
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
def registro():
  if(request.method=='POST'):
    username=request.form.get('usuario')
    if (username!=None):
      root=app.root_path +'/data/usuarios/'
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
        return redirect("../")


    return render_template('registro.html', existe=None)

  else:
    return render_template('registro.html', existe=None)

@app.route('/cuenta/')
def cuenta():
  if('username' in session):
    root=app.root_path + '/data/usuarios/'
    ruta = root+session['username']+"/data.json"
    datosUsuario = json.load(open(ruta))
    return render_template('cuenta.html',log = datosUsuario)
  else:
    return render_template('cuenta.html',log = None)

@app.route('/finalizarCompra/')
def finalizarCompra():
  films_cat = json.load(open(app.root_path + '/data/catalogo.json'))['peliculas']
  try:
    carrito = session['carrito']
  except KeyError:
    carrito=[]
    sumPrice=0
  else:
    sumPrice = 0
    carrito = [x for x in carrito if x[0] in films_cat]
    for film in carrito:
      sumPrice += (film[0]['precio']*film[1])
  root=app.root_path + '/data/usuarios/'
  ruta = root+session['username']+"/data.json"
  saldo = json.load(open(ruta))['saldo']
  if('username' in session):
    return render_template('finalizarCompra.html', films = carrito, sumPrice = sumPrice, log = session['username'], saldo=saldo)
  else:
    return render_template('finalizarCompra.html', films = carrito, sumPrice = sumPrice, log = None, saldo=None)

@app.route('/historialCompras/')
def historialCompras():
  films = json.load(open(app.root_path + '/data/catalogo.json'))['peliculas']
  if('username' in session):
    root=app.root_path +'/data/usuarios/'
    ruta = root+session['username']+"/historial.json"
    historialUsuario = json.load(open(ruta))['peliculas']
    fechas = []
    for film in historialUsuario:
      if film['fechaCompra'] not in fechas:
        fechas.append(film['fechaCompra'])

    return render_template('historialCompras.html', films = historialUsuario, log = session['username'], fechas=fechas)
  else:
    return render_template('historialCompras.html', films = None, log = None)

@app.route('/pelicula/<path:name>', methods = ['POST', 'GET'])
def pelicula(name, methods = ['POST', 'GET']):
  films = json.load(open(app.root_path + '/data/catalogo.json'))['peliculas']
  if request.method=='GET':
    for film in films:
      if int(name) == film['id']:
        if('username' in session):
          return render_template('pelicula.html', film = film, log = session['username'])
        else:
          return render_template('pelicula.html', film = film, log = None)
    if('username' in session):
      return render_template('pelicula.html', film = None, log = session['username'])
    else:
      return render_template('pelicula.html', film = None, log = None)

  if request.method=='POST':
    for film in films:
      if(int(name) == film['id']):
        # Si no hay carrito
        try:
          carrito=session['carrito']
        except KeyError:
          # Si no hay carrito
          session['carrito']=[]
          carrito=session['carrito']
        # Buscamos la pelicula en el carrito

        for i in range(len(carrito)):
          # Si la encontramos en el carritos
          if carrito[i][0]['id']==film['id']:
            carrito[i][1]+=int(request.form['quantity'])
            session['carrito']=carrito
            return redirect("../carrito")

          # Si no la hemos encontrado en el carrito

        session['carrito']=carrito + [[film, int(request.form['quantity'])]]
        return redirect("../carrito")



    return redirect("../carrito")

@app.route('/logout/')
def logout():
  session.clear()
  return redirect("../")

@app.route('/contador', methods=['POST'])
def contador():
    number=''
    for muda in range(4):
        number+=str(random.randint(0,9))
    return number

@app.route('/confirmar/')
def confirmar():
    films_cat = json.load(open(app.root_path +'/data/catalogo.json'))['peliculas']
    root=app.root_path +'/data/usuarios/'
    ruta = root+session['username']+"/data.json"
    rutaHistorial = root+session['username']+"/historial.json"
    saldo = json.load(open(ruta))['saldo']
    usuario = json.load(open(ruta))
    historial = json.load(open(rutaHistorial))
    fecha = datetime.date.today()
    try:
        carrito = session['carrito']
    except KeyError:
        carrito=[]
        sumPrice=0
    else:
        sumPrice = 0
        carrito = [x for x in carrito if x[0] in films_cat]
    for film in carrito:
        sumPrice += (film[0]['precio']*film[1])
        flag=0
        for peli in historial['peliculas']:
          if film[0]['id'] == peli['id'] and peli['fechaCompra'] == str(fecha):
            peli['cantidad'] += film[1]
            flag=1
            break
        if flag== 0:
          film[0]['cantidad'] = film[1]
          film[0]['fechaCompra']=str(fecha)
          historial['peliculas'].append(film[0])
        if sumPrice > saldo:
            return redirect("../")

    saldo = saldo-sumPrice
    session['carrito']=[]
    usuario['saldo'] = saldo
    with open(ruta, "w") as jfile:
        json.dump(usuario, jfile)
    with open(rutaHistorial, "w") as jfile:
        json.dump(historial, jfile)

    return redirect("../")


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
