// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

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
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let Hooks = {};

Hooks.QrCode = {
  mounted() {
    var qrcode = new QRCode(document.getElementById("qrcode"), {
      width: 180,
      height: 180,
    });

    function makeCode() {
      var elText = document.getElementById("text");

      if (!elText.value) {
        alert("Input a text");
        elText.focus();
        return;
      }

      qrcode.makeCode("https://mwambarugby.com/tickets/" + elText.value);
    }

    makeCode();
  },
  updated() {
    var qrcode = new QRCode(document.getElementById("qrcode"), {
      width: 300,
      height: 300,
    });

    function makeCode() {
      var elText = document.getElementById("text");

      if (!elText.value) {
        alert("Input a text");
        elText.focus();
        return;
      }

      qrcode.makeCode("https://mwambarugby.com/tickets/" + elText.value);
    }

    makeCode();
  },
};
Hooks.Copy = {
  mounted() {
    const copyButton = document.querySelector(".clipboardCopy");
    copyButton.addEventListener("click", clipboardCopy);

    async function clipboardCopy(event) {
      const copyButton = event.target;
      const parentTd = copyButton.parentElement;
      const textInput = parentTd.querySelector(".copyable");
      Toastify({
        text: "Copied to clipboard",
        className: "info",
        style: {
          background: "linear-gradient(to right, #00b09b, #96c93d)",
        },
        duration: 2000,
      }).showToast();

      if (textInput) {
        const text = textInput.value;
        await navigator.clipboard.writeText(text);
      }
    }
  },
};

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
