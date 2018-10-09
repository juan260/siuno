function updateSearch(){
  var text=document.getElementById("searchBarBar").value;
  var noResultsFlag = 1;
  var films=document.getElementsByClassName("film")
  for(const film of films){
    if(film.dataset.title.search(text)==0){
      noResultsFlag = 0;
      film.style.visibility="visible";
      document.getElementById("franksearch").style.visibility="hidden";
    } else {
      film.style.visibility="hidden";
    }
  }

  if(noResultsFlag==1){
    document.getElementById("franksearch").style.visibility="visible";
    noResultsFlag=0;
  }
  
}
