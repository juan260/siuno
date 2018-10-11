function checkRegister(){
  var usuario = document.getElementById('usuarioField').value
  var nombre = document.getElementById('nombreField').value
  var apellidos = document.getElementById('apellidosField').value
  var correo = document.getElementById('correoField').value
  var contrasenia = document.getElementById('contraseniaField').value
  var confContrasenia= document.getElementById('confContraseniaField').value
  var tarjeta = document.getElementById('tarjetaField').value
  var secretNum = document.getElementById('secretNumField').value


	if (usuario < 2) {
		alert('El nombre de usuario debe tener una longitud mayor o igual a dos');
		return false;
	} else if (usuario[0] == ' ' || usuario[usuario.len - 1] == ' ') {
	   alert('El nombre de usuario no debe acabar ni empezar con espacios');
		return false;
	} else if (nombre[0] == ' ' || nombre[area1Length - 1] == ' ') {
	   alert('El nombre de usuario no debe acabar ni empezar con espacios');
		return false;
	} else if ( isNaN(edad) || edad < 0 || edad > 300 ) {
		alert('Edad no valida');
		return false;
	} else if ((email.indexOf("@") <= 0) || (email.indexOf("@") >= (email.length - 1))) {
		alert('Email no valido');
		return false;
	}
}
