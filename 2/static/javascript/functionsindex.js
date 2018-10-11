function updateSearch(){
  var text=document.getElementById("searchBarBar").value;
  var lcText = text.toLowerCase()
  console.log(lcText)
  var noResultsFlag = 1;
  var films=document.getElementsByClassName("film")
  var findPos;
  for(const film of films){
    findPos = film.dataset.title.toLowerCase().search(lcText)
    if(findPos >=0){
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
