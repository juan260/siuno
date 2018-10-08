from flask import Flask, request, render_template
import json
app = Flask(__name__)


# Funcion que devuelve el link que dirige
# a una pelicula concreta TODO
def getlink(film):
    return "pelicula.html"

@app.route('/')
def index():
    films = json.load(open('../data/catalogo.json'))['peliculas']
    #print(open('../html/index.html').read()) #Esto lo ace bien wtf
    #pero esto dice que no existe '../html/index.html'
    return render_template('../html/index.html', films = films)


if __name__ == '__main__':
   app.run(debug = True)
