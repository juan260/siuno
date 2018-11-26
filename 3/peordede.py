from flask import Flask, request, render_template, redirect, session, url_for
import json
import os
import random
import md5
import sys
import datetime
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgres://alumnodb@localhost/si1'
#db = SQLAlchemy(app)
Base = automap_base()
engine = create_engine("postgres://alumnodb@localhost/si1")
Base.prepare(engine, reflect=True)
connection = engine.connect()
sys.path.append('~/apache2/var/www/html/')
app.secret_key = 'teamoluis'
app.root_path=os.path.dirname(os.path.abspath(__file__))

# Funcion que se ejecuta cada vez que un usuario inicia session
# o se registre, mueve el carrito actual al de la base de datos
def loggedInAs(username):
    session['username']=username
    session['customerid']=connection.execute("select customerid from customers \
        where username = \'" + username + "\'").fetchone()['customerid']
    # Movemos el carrito actual a la base de datos
    if 'carrito' in session:
        carritoViejo = session['carrito']
        #ESTA LINEA SIGUIENTE ES IMPORTANTE QUE ESTE AQUI
        session['carrito'] = carritoaux(session['customerid'])
        if len(carritoViejo)>0:
            query = "insert into orderdetail (orderid, prod_id, price, quantity) values "
            for producto in carritoViejo:
                query +="(" + str(session['carrito']) + ", " + \
                    str(producto[0]['prod_id']) + ", " + \
                    str(producto[0]['price']) + ", " + \
                    str(producto[1]) +  "); "
            connection.execute(query)
    else:
        #ESTA LINEA SIGUIENTE ES IMPORTANTE QUE ESTE AQUI
        session['carrito'] = carritoaux(session['customerid'])



# Funcion auxiliar para crear el carrito, o devolverlo en caso de que exista
# DEVUELVE EL ORDERID DEL CARRITO
def carritoaux(customerid):
    # Comprobar si existe el carrito
    #print("CREANDO CARRITO PARA USUARIO " + str(customerid))
    carr=connection.execute("select orderid from orders where status is NULL and customerid = " +
        str(customerid) + ";").fetchall()

    if(len(carr)==0):
        connection.execute("select createCarrito(" + str(customerid) + ")")
        return connection.execute("select orderid from orders where status is NULL and customerid = " +
            str(customerid) + ";").fetchone()['orderid']
    #Si existe el carrito
    else:
        return carr[0]['orderid']

@app.route('/', methods = ['POST', 'GET'])
def index(methods = ['POST', 'GET']):
  genres = [genre[0] for genre in connection.execute("select genre from genres;").fetchall()]
  genres.sort()
  search=request.args.get('busqueda')
  genre=request.args.get('filters')
  top = None
  busqueda = None
  # He intentado combinar generos y busqueda pero no h epodido :( BORRAR
  if search != None:
    busqueda=search
    films = connection.execute("SELECT *\
      FROM imdb_movies AS m , products as p\
      WHERE m.movieid=p.movieid AND UPPER(movietitle) LIKE UPPER('%%" +  str(search) +"%%');").fetchall()
  else:
      if(not(genre==None or genre=='Todas')):
        top = genre
        if(search == None):
            films = connection.execute("select * \
                  from products as p, imdb_movies as f, imdb_moviegenres AS g\
                  where genre='" + genre + "' AND f.movieid=g.movieid AND p.movieid=f.movieid;").fetchall()
        #else:
        #    busqueda=search
        #    films = connection.execute("select * \
        #          from products as p, imdb_movies as f, imdb_moviegenres AS g\
        #          where genre='" + genre + "' AND f.movieid=g.movieid AND p.movieid=f.movieid AND UPPER(movietitle) LIKE UPPER('%%" +  str(search) +"%%');").fetchall()
      elif (genre == 'Todas'):
        top = 0
        if(search==None):
            films = connection.execute("select * \
            from products as p, imdb_movies as f\
            where p.movieid=f.movieid;").fetchall()
        #else:
        #    busqueda=search
        #    films = connection.execute("select * \
        #    from products as p, imdb_movies as f\
        #    where p.movieid=f.movieid AND UPPER(movietitle) LIKE UPPER('%%" +  str(search) +"%%');").fetchall()
        if('username' in session):
            return render_template('index.html', films = films, genres = genres, top = top, busqueda=busqueda, log = session['username'])
        else:
            return render_template('index.html', films = films, genres = genres, top = top, busqueda=busqueda, log = None)
      else:
        top="top"
        if(search == None):
            films = connection.execute("SELECT *\
                    FROM products as p,  (imdb_movies AS m INNER JOIN getTopVentas(2015) AS t ON m.movietitle=t.movietitle1) as s\
                    WHERE p.movieid= s.movieid;").fetchall()
        #else:
        #    busqueda=search
        #    films = connection.execute("SELECT *\
        #        FROM imdb_movies AS m , products as p\
        #        WHERE m.movieid=p.movieid AND UPPER(movietitle) LIKE UPPER('%%" +  str(search) +"%%');").fetchall()
  if('username' in session):
    return render_template('index.html', films = films, genres = genres, top = top, busqueda=busqueda, log = session['username'])
  else:
    return render_template('index.html', films = films, genres = genres, top = top, busqueda=busqueda, log = None)


@app.route('/carrito/', methods=['GET','POST'])
def carrito(methods=['GET','POST']):
  #try:
#    carrito = 88699 #session['carrito']
#  except KeyError:
#    carrito = 0

    # BORRAR OJO, SI QUIERES PROBAR EL CARRITO, PON O.ORDERID = 88699


  if(request.method=='POST'):
    del_film_id=request.form.get('id')
    if('username' in session):
        connection.execute("DELETE FROM orderdetail\
            WHERE orderid= " + str(carrito) + " and prod_id =" + del_film_id + ";")
    else:
        if('carrito' in session):
            newCarrito = []
            for film in session['carrito']:
                if int(film[0]['prod_id'])!=int(del_film_id):
                    print("SONIGUALESSSS????")
                    print(film[0]['prod_id'])
                    print(del_film_id)
                    newCarrito.append(film)
            session['carrito']=newCarrito
    return redirect(url_for("carrito"))

  sumPrice=0
  if('username' in session):

    films = connection.execute("select *\
          from products as p, orderdetail as od, orders as o, imdb_movies as m\
          where p.prod_id = od.prod_id and o.orderid = od.orderid and o.orderid = " + str(session['carrito']) + " and o.status is NULL and m.movieid=p.movieid;").fetchall()
    for film in films:
      sumPrice += film['price']
    return render_template('carrito.html', films = films, log = session['username'], sumPrice=sumPrice)
  else:
    filmsEdited = []
    if('carrito' in session):
      films = session['carrito']
      for film in films:
        sumPrice += film[0]['price']*film[1]
        film[0]['quantity']=film[1]
        filmsEdited.append(film[0])
    else:

      sumPrice=0

    return render_template('carrito.html', films = filmsEdited, log = None, sumPrice=sumPrice)

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
      # Obtenemos la contrasenia asociada al usuario,
      # la lista passwords tendra longitud 1 o 0
      passwords = list(connection\
        .execute("select password from customers where username = \'" + \
        username + "\';"))
      # Si existe la password, existe el usuario
      if len(passwords) > 0:
        contrasenia=passwords[0][0]
        if contrasenia == md5.new(request.form.get('contrasenia')).hexdigest():
          loggedInAs(username)
          return redirect(url_for("index"))
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

      existeUser = len(list(connection\
        .execute("select username from customers where username = \'" + \
        username + "\';")))
      if existeUser > 0:
        return render_template('registro.html', existe=1)

      connection.execute("insert into customers "
        "(username, firstname, lastname, password, "
        "email, creditcard, creditcardtype, creditcardexpiration, address1, "
        "country, zip, city) "
        " values (\'" + username + "\', \'" + \
        request.form.get('nombre') + "\', \'" +\
        request.form.get('apellidos') + "\', \'" + \
        md5.new(request.form.get('contrasenia')).hexdigest() + \
        "\', \'" + request.form.get('correo') + "\', \'" + \
        request.form.get('tarjeta') + "\', \'" + \
        request.form.get('tarjetaTipo') + "\', \'" + \
        request.form.get('expiration') + "\', \'" + \
        request.form.get('direccion') + "\', \'" + \
        request.form.get('country') + "\', \'" + \
        request.form.get('zip') + "\', \'" + \
        request.form.get('city') + \
        "\');")

      loggedInAs(username)

      return index()


    return render_template('registro.html', existe=None)

  else:
    return render_template('registro.html', existe=None)

@app.route('/cuenta/', methods = ['POST', 'GET'])
def cuenta():
  if('username' in session):
    datosUsuario = connection.execute("select * " + \
      "from customers where username = \'" + \
      session['username'] + "\'").fetchone()

    if(request.method=='POST'):
      incr=int(request.form.get('quantity'))
      newSaldo=datosUsuario['income']+incr
      connection.execute("update customers " + \
        "set income = " + str(newSaldo))
      datosUsuario = connection.execute("select * " + \
      "from customers where username = \'" + \
      session['username'] + "\'").fetchone()
    return render_template('cuenta.html',log = datosUsuario)
  else:
    return render_template('cuenta.html',log = None)

@app.route('/finalizarCompra/')
def finalizarCompra():
  try:
    carrito = 88699 #session['carrito']
  except KeyError:
    carrito=0

  films = connection.execute("select *\
          from products as p, orderdetail as od, orders as o, imdb_movies as m\
          where p.prod_id = od.prod_id and o.orderid = od.orderid and o.orderid = " + str(carrito) + " and o.status is NULL and m.movieid=p.movieid;").fetchall()


  if('username' in session):
    saldo = connection.execute("select income\
            from customers\
            where username= '" + session['username']+ "';").fetchall()
    print("saldoooo" + str(saldo))
    return render_template('finalizarCompra.html', films = films, log = session['username'], saldo=saldo)
  else:
    return render_template('finalizarCompra.html', films = films, log = None, saldo=None)

@app.route('/historialCompras/')
def historialCompras():
  if('username' in session):
    historialUsuario = connection.execute("SELECT * \
        FROM products as p, orders as o, orderdetail as od, imdb_movies as m\
        WHERE p.prod_id=od.prod_id AND od.orderid=o.orderid AND o.customerid=" + str(session['customerid']) + " AND status IS NOT NULL AND m.movieid=p.movieid;").fetchall()
    fechas = []
    for film in historialUsuario:
      if film['orderdate'] not in fechas:
        fechas.append(film['orderdate'])

    return render_template('historialCompras.html', films = historialUsuario, log = session['username'], fechas=fechas)
  else:
    return render_template('historialCompras.html', films = None, log = None)

@app.route('/pelicula/<path:name>', methods = ['POST', 'GET'])
def pelicula(name, methods = ['POST', 'GET']):
  if request.method=='GET':
    film = connection.execute("select * \
          from products as p, imdb_movies as f, imdb_moviegenres AS g\
          where p.prod_id=" + str(name) + " AND f.movieid=g.movieid AND p.movieid=f.movieid;").fetchall()[0]
    directors = connection.execute("SELECT *\
        FROM imdb_directors AS d, imdb_directormovies AS dm, products AS p\
        WHERE dm.movieid = p.movieid AND p.prod_id=" + str(name) + " AND d.directorid=dm.directorid;").fetchall();
    actors = connection.execute("SELECT *\
        FROM imdb_actors AS a, imdb_actormovies AS am, products AS p\
        WHERE am.movieid = p.movieid AND p.prod_id=" + str(name) + " AND am.actorid=a.actorid;").fetchall();
    if film:
        if('username' in session):
          return render_template('pelicula.html', film = film, directors = directors, actors = actors, log = session['username'])
        else:
          return render_template('pelicula.html', film = film, directors = directors, actors = actors, log = None)
    else:
        if('username' in session):
          return render_template('pelicula.html', film = None, directors = None, actors = None, log = session['username'])
        else:
          return render_template('pelicula.html', film = None, directors = None, actors = None, log = None)

  if request.method=='POST':

    films = connection.execute("select * \
          from products as p, imdb_movies as f\
          where p.movieid=f.movieid;").fetchall()

    for film in films:
      film = dict(film)
      if(int(name) == film['prod_id']):

        # Si el usuario no esta loggeado, metemos el carrito en la sesion
        if('username' not in session):

            # Si no hay carrito
            try:
              carrito=session['carrito']
            except KeyError:
              # Si no hay carrito
              session['carrito']=[]
              carrito=session['carrito']

            # Buscamos la pelicula en el carrito


            for i in range(len(carrito)):
              print("AQUI SIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII6")
              # Si la encontramos en el carrito
              if carrito[i][0]['prod_id']==film['prod_id']:

                carrito[i][1]+=int(request.form['quantity'])
                session['carrito']=carrito
                print(session['carrito'])
                return redirect(url_for("carrito"))

              # Si no la hemos encontrado en el carrito

            session['carrito']=carrito + [[film, int(request.form['quantity'])]]
        # Si el usuario esta loggeado metemos el carrito en la base de datos
        else:
            # Comprobamos si esta ya el producto en el carrito
            query=connection.execute("select quantity from orderdetail \
                    where orderid = "+ str(session['carrito']) + \
                    " and prod_id = "+ str(film['prod_id']) + ";").fetchall()
            if len(query) > 0:
                quantity = int(request.form['quantity']) + int(query[0]['quantity'])
                connection.execute("update orderdetail\
                    set quantity = " + str(quantity) + \
                    "where orderid = "+ str(session['carrito']) + \
                    " and prod_id = "+ str(film['prod_id']) + ";")
            #Si no esta en el carrito
            else:
                connection.execute("insert into orderdetail \
                    (prod_id, orderid, price, quantity) \
                    VALUES ("+ str(film['prod_id'])+ ", "+ str(session['carrito']) +\
                    ", "+ str(film['price']) + ", " + str(request.form['quantity']) + ")")

        return redirect(url_for("carrito"))

    return redirect(url_for("carrito"))

@app.route('/logout/')
def logout():
  session.clear()
  return redirect(url_for("index"))

@app.route('/contador', methods=['POST'])
def contador():
    number=''
    for muda in range(4):
        number+=str(random.randint(0,9))
    return number

@app.route('/confirmar/')
def confirmar():
    # films_cat = json.load(open(app.root_path +'/data/catalogo.json'))['peliculas']
    # root=app.root_path +'/data/usuarios/'
    # ruta = root+session['username']+"/data.json"
    # rutaHistorial = root+session['username']+"/historial.json"
    #saldo = list(connection.execute("select income from customers where username = \'" + \
    #  session['username'] + "\';"))[0]
    #usuario = json.load(open(ruta))
    usuario = connection.execute("select * from customers where username = \'" + \
      session['username'] + "\';").fetchone()
    historial = connection.execute("select * from imdb_movies," + \
        "(select movieid from orders, orderdetail where customerid = \'" + \
        usuario['customerid'] + "\' and orders.orderid = orderdetail.orderid)" + \
        " as moviesOfUser where imdb_movies.movieid = moviesOfUser.movieid").fetchall()
    saldo = usuario['income']
    fecha = datetime.date.today()
    films_cat = connection.execute("select * from imdb_movies").fetchall()
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
        for peli in historial:
          if film[0]['id'] == peli['id'] and peli['fechaCompra'] == str(fecha):
            peli['cantidad'] += film[1]
            flag=1
            break
        if flag== 0:
          film[0]['cantidad'] = film[1]
          film[0]['fechaCompra']=str(fecha)
          #historial['peliculas'].append(film[0])

        if sumPrice > saldo:
            return redirect(url_for("index"))

    saldo = saldo-sumPrice
    session['carrito']=[]
    connection.execute("update customers set income = " + str(saldo))
    #with open(rutaHistorial, "w") as jfile:
    #    json.dump(historial, jfile)

    return redirect(url_for("index"))


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
