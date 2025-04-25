
if(localStorage.theme){
    document.querySelector("html").setAttribute("data-theme", localStorage.theme)
} else {
   if(window.matchMedia("(prefers-color-scheme: dark)")){
        document.querySelector("html").setAttribute("data-theme", "blue-dark")
   } else {
        document.querySelector("html").setAttribute("data-theme", "blue")
   }
}
