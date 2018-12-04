from flask import Flask, request, render_template, redirect, session, url_for
import app.database as db
import os, sys

app = Flask(__name__)
app.secret_key = 'teamoluis'
app.root_path=os.path.dirname(os.path.abspath(__file__))
sys.path.append('~/apache2/var/www/html/')


@app.route('/', methods = ['POST', 'GET'])
def index(methods = ['POST', 'GET']):
    if request.method == 'GET':
        return render_template('index.html')

    if request.method == 'POST':
        mes = request.form.get('mes')
        anio = request.form.get('anio')
        iumbral = request.form.get('iumbral')
        iintervalo = request.form.get('iintervalo')
        use_prepare = request.form.get('use_repare')
        break0 = request.form.get('break0')
        niter = request.form.get('niter')
        results = db.getListaCliMes(int(mes), int(anio), int(iumbral), int(iintervalo), int(use_prepare), int(break0), int(niter))
        print(results)
        return render_template('lista.html', results=results)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
