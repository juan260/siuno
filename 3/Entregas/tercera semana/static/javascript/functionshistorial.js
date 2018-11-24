function updateDate(){
  var fecha=document.getElementById("fecha").value;
  var films=document.getElementsByClassName("film")
  var findPos;
  for(const film of films){
    if(fecha == "Todas"){
      film.style.display="block";
      film.style.alignItems="center";
    }
      else{
      fechaPeli = film.dataset.fecha
      if(fechaPeli == fecha){
        film.style.display="block";
        film.style.alignItems="center";
      } else {
        film.style.display="none";
      }
    }
  }
}