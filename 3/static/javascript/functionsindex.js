function updateSearch(){
  var text=document.getElementById("searchBarBar").value;
  var lcText = text.toLowerCase()
  var noResultsFlag = 1;
  var films=document.getElementsByClassName("film")
  var findPos;
  for(const film of films){
    findPos = film.dataset.title.toLowerCase().search(lcText)
    if(findPos >=0){
      noResultsFlag = 0;
      film.style.display="block";
      film.style.alignItems="center";
      document.getElementById("franksearch").style.visibility="hidden";
    } else {
      film.style.display="none";
    }
  }

  if(noResultsFlag==1){
    document.getElementById("franksearch").style.visibility="visible";
    noResultsFlag=0;
  }

}
