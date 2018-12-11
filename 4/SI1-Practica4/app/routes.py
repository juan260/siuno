# -*- coding: utf-8 -*-

from app import app
from app import database
from flask import render_template, request, url_for
import os
import sys
import time

@app.route('/borraCliente', methods=['POST','GET'])
def borraCliente():
    print request.form
    if 'customerid' in request.form:
        customerid = request.form["customerid"]
        bSQL       = request.form["txnSQL"]
        bCommit = "bCommit" in request.form
        bFallo  = "bFallo"  in request.form
        duerme  = request.form["duerme"]
        dbr = database.delCustomer(customerid, bFallo, bSQL=='1', int(duerme), bCommit)
        return render_template('borraCliente.html', dbr=dbr)
    else:
        return render_template('borraCliente.html')

@app.route('/xSearchInjection', methods=['GET'])
def xSearchInjection():
    if 'i_anio' in request.args:
        anio  = request.args['i_anio']
        dbr = database.getMovies(anio)
        return render_template('xSearchInjection.html', dbr=dbr)
    else:
        return render_template('xSearchInjection.html')

@app.route('/xLoginInjection', methods=['GET','POST'])
def xLoginInjection():
    if 'login' in request.form:
        login  = request.form['login']
        pswd   = request.form['pswd']
        dbr = database.getCustomer(login, pswd)
        return render_template('xLoginInjection.html', dbr=dbr)
    else:
        return render_template('xLoginInjection.html')

@app.route('/listaClientesMes', methods=['GET', 'POST'])
def listaClientesMes():
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
        results, time = db.getListaCliMes(int(mes), int(anio), int(iumbral), int(iintervalo), int(use_prepare), int(break0), int(niter))

        return render_template('lista.html', results=results, time=time)
