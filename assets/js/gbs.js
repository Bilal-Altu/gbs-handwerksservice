/* =============================================================================
   GBS Handwerksservice
   1. Leiste erscheint nach dem ersten Schirm
   2. Einblenden beim Scrollen
   3. Anfrageformular (baut eine E-Mail, kein Server)
   ========================================================================== */
(function () {
  "use strict";

  var sparsam = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* ------------------------------------------------------- 1. Leiste --- */
  var leiste = document.querySelector(".leiste");
  var schirm = document.querySelector(".schirm");

  function beimScrollen() {
    if (!leiste) { return; }
    /* Ohne ersten Schirm — also auf Impressum und Datenschutz — steht die
       Leiste von Anfang an. */
    if (!schirm) { leiste.setAttribute("data-fest", "ja"); return; }
    var y = window.scrollY || window.pageYOffset;
    leiste.setAttribute("data-fest", y > schirm.offsetHeight - 80 ? "ja" : "nein");
  }
  window.addEventListener("scroll", beimScrollen, { passive: true });
  window.addEventListener("resize", beimScrollen);
  beimScrollen();

  /* --------------------------------------------------- 2. Einblenden --- */
  var bloecke = document.querySelectorAll(".auf");
  document.documentElement.classList.add("js-an");
  document.documentElement.dataset.bereit = "ja";

  if (!("IntersectionObserver" in window) || sparsam) {
    Array.prototype.forEach.call(bloecke, function (el) { el.setAttribute("data-da", "ja"); });
  } else {
    var beobachter = new IntersectionObserver(function (eintraege) {
      eintraege.forEach(function (e) {
        if (e.isIntersecting) {
          e.target.setAttribute("data-da", "ja");
          beobachter.unobserve(e.target);
        }
      });
    }, { rootMargin: "0px 0px -8% 0px", threshold: 0.05 });
    Array.prototype.forEach.call(bloecke, function (el) { beobachter.observe(el); });
  }

  /* ----------------------------------------------------- 3. Formular --- */
  var formular = document.getElementById("anfrage");
  if (!formular) { return; }

  var rueck    = document.getElementById("rueckmeldung");
  var feld     = document.getElementById("entwurf");
  var kopieren = document.getElementById("kopieren");

  /* Ohne Telefon oder E-Mail können wir nicht antworten — das prüft der
     Browser selbst, statt dass die Anfrage später ins Leere läuft. */
  var tel  = formular.elements.telefon;
  var mail = formular.elements.email;
  function pruefen() {
    var da = tel.value.trim() !== "" || mail.value.trim() !== "";
    tel.setCustomValidity(da ? "" :
      "Bitte Telefon oder E-Mail angeben — sonst können wir nicht antworten.");
  }
  tel.addEventListener("input", pruefen);
  mail.addEventListener("input", pruefen);
  pruefen();

  formular.addEventListener("submit", function (e) {
    e.preventDefault();
    var d = new FormData(formular);
    var text =
      "Name: "    + (d.get("name")    || "") + "\n" +
      "Telefon: " + (d.get("telefon") || "") + "\n" +
      "E-Mail: "  + (d.get("email")   || "") + "\n" +
      "Raum: "    + (d.get("raum")    || "") + "\n\n" +
      (d.get("nachricht") || "");

    var betreff = "Anfrage Spanndecke" + (d.get("raum") ? " — " + d.get("raum") : "");

    if (feld)  { feld.value = text; }
    if (rueck) {
      rueck.hidden = false;
      rueck.scrollIntoView({ block: "nearest", behavior: sparsam ? "auto" : "smooth" });
    }

    window.location.href = "mailto:christian-klein@gbs-handwerksservice.de" +
      "?subject=" + encodeURIComponent(betreff) +
      "&body="    + encodeURIComponent(text);
  });

  if (kopieren && feld) {
    kopieren.addEventListener("click", function () {
      var fertig = function () {
        kopieren.textContent = "Kopiert";
        window.setTimeout(function () { kopieren.textContent = "Text kopieren"; }, 2200);
      };
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(feld.value).then(fertig, function () {
          feld.select(); document.execCommand("copy"); fertig();
        });
      } else {
        feld.select(); document.execCommand("copy"); fertig();
      }
    });
  }
})();
