function checkRegister(){
  var usuario = document.getElementById('usuarioField').value;
  var nombre = document.getElementById('nombreField').value;
  var apellidos = document.getElementById('apellidosField').value;
  var correo = document.getElementById('correoField').value;
  var contrasenia = document.getElementById('contraseniaField').value;
  var confContrasenia= document.getElementById('confContraseniaField').value;
  var tarjeta = document.getElementById('tarjetaField').value;
  var secretNum = document.getElementById('secretNumField').value;
  var tarjetaInvalidaFlag = 0;
  var secretNumInvalidoFlag = 0;
  var acceptTerms = document.getElementById("agree").checked;

  for(letter in tarjeta){
    if(isNaN(Number(letter))){
      tarjetaInvalidaFlag = 1;
      break;
    }
  }

  for(letter in secretNum){
    if(isNaN(Number(letter))){
      secretNumInvalidoFlag = 1;
      break;
    }
  }

	if (usuario < 2) {
		alert('El nombre de usuario debe tener una longitud mayor o igual a dos');
		return false;
	} else if (usuario.includes(" ") || usuario.includes("/") || usuario.includes("&") || usuario.includes("=") || usuario.includes("%")) {
	   alert('Nombre de usuario inválido, no se deben incluir espacios, /, &, = o %');
		return false;
  } else if (nombre[0] == ' ' || nombre[nombre.length - 1] == ' ') {
	   alert('El nombre no debe acabar ni empezar con espacios');
		return false;
	} else if (apellidos[0] == ' ' || apellidos[apellidos.length - 1] == ' ') {
	   alert('Los apellidos no deben acabar ni empezar con espacios');
		return false;
	} else if(contrasenia.length < 8){
    alert('Contraseña inválida');
    return false;
  } else if (contrasenia != confContrasenia) {
	   alert('Las contraseñas no coinciden');
		return false;
	} else if (tarjeta.length != 16 || tarjetaInvalidaFlag == 1) {
	   alert('Numero de tarjeta inválido (deben ser 16 números sin espacios)');
		return false;
	} else if (secretNum.length != 3 || secretNumInvalidoFlag == 1) {
	   alert('Numero de secreto inválido');
		return false;
	} else if (acceptTerms != true){
    alert('Por favor, acepte los términos y condiciones');
    return false;
  }￼
acromi,p derecirsovbp
￼
￼

}
/*
function checkUsr(){
  var usuario = document.getElementById('usuarioField').value;
  const folder = "../data/usuarios/"
  const faux = require("faux")

  faux.readdirSync(folder).forEach(file =>{console.log(file)})
}*/

function checkPwd() {
    var contrasenia = document.getElementById('contraseniaField').value

    if(contrasenia.length < 8 ){
       document.getElementById("securityMeter").innerHTML ="Contraseña inválida";
       document.getElementById("securityMeter").style.color= "red";
    } else if (contrasenia.length > 15 ){
      document.getElementById("securityMeter").innerHTML ="Contraseña segura";
      document.getElementById("securityMeter").style.color= "green";
    }  else {
      document.getElementById("securityMeter").innerHTML = "Contraseña aceptable"
      document.getElementById("securityMeter").style.color= "orange";
    }
}
