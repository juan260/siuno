function updateSearch(){
  text=document.getElementById("searchBarBar").value;
  var noResultsFlag = 1;
  console.log(text);
  for(film in document.getElementsByClassName("film")){
    console.log(film.dataset.title);
    if(film.dataset.title.search(text)==0){
      noResultsFlag = 0;
      film.style.visibility="visible";
    } else {
      film.style.visibility="hidden";
    }
  }
  if(noResultsFlag==1){
    document.getElementById("filmtable").innerHTML = "Oh no";
  }

}
