// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
let Hooks = {}
Hooks.HandleTheme = {
  mounted() {
    const select = document.getElementById("theme_switcher_select")
    const html = document.querySelector("html")
    let theme = localStorage.getItem("theme")
  
    if(select !== null) {
      Array.from(select.options).map(o => {
        if(o.value === theme){
          o.setAttribute("selected", true)
        }
      })
       
      select.addEventListener("input", (e) => {
        html.setAttribute("data-theme", e.target.value)
        localStorage.setItem("theme", e.target.value)
      })
    }
  }
}

Hooks.HandleCopy = {
    mounted() {
      const pre = document.querySelectorAll("pre")
      pre.forEach(p => {
        createAndAddCopyButton(p)
      })
    }
}
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken}
})


// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

const createAndAddCopyButton = (element) => {
  const code = element.querySelector("code")
  const article = document.querySelector("article")
  const button = document.createElement("button")
  const div = document.createElement("div")
  
  div.classList.add("relative")
  button.classList.add("right-2")
  button.classList.add("right-2")
  button.classList.add("text-text-ui")
  button.classList.add("top-2")
  button.classList.add("h-8")
  button.classList.add("w-16")
  button.classList.add("bg-accent/70")
  button.classList.add("rounded-md")
  button.classList.add("font-semibold")
  button.classList.add("hover:bg-accent")
  button.classList.add("transition")
  button.classList.add("absolute")
  button.title = "Copy bellow code"
  button.innerHTML = "Copy"

  div.append(button)
  article.insertBefore(div, element)
  element.remove()
  div.append(element)
  button.addEventListener("click", (event) => copyFunction(event, code))
}
const notifyAndCleanUp = (event) => {
  setTimeout(()=>{
    event.target.classList.remove("scale-110")
    event.target.innerHTML = "Copy"
  }, 1000)
  event.target.classList.add("scale-110")
  event.target.innerHTML = "Copied!"
}
const copyFunction = (event, code) => {
  if("clipboard" in navigator){
      navigator.clipboard.writeText(code.innerHTML) 
      notifyAndCleanUp(event)
  } else {
      alert("Sorry, your browser does not support clipboard copy")
  }
}