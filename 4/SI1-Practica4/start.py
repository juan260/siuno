from flask import Flask, request, render_template, redirect, session, url_for
import app.database

app = Flask(__name__)
app.secret_key = 'teamoluis'
app.root_path=os.path.dirname(os.path.abspath(__file__))
sys.path.append('~/apache2/var/www/html/')


@app.route('/', methods = ['POST', 'GET'])
def index(methods = ['POST', 'GET']):
    if request.method == 'GET':
        render_template('index.html')
        
    if request.method == 'POST':
        mes = request.form.get('mes')
        anio = request.form.get('anio')
        iumbral = request.form.get('iumbral')
        iintervalo = request.form.get('iintervalo')
        use_prepare = request.form.get('use_repare')
        break0 = request.form.get('break0')
        niter = request.form.get('niter')
        results = getListaCliMes(mes, anio, iumbral, iintervalo, use_prepare, break0, niter)
        render_template('lista.html', results=results)
