/* =============================================================================
   GBS Handwerksservice
   1. Haarlinie unter dem Kopf, sobald man scrollt
   2. Einblenden beim Scrollen
   3. Leistungen: vier Reiter, eine Zeichnung
   4. Anfrageformular (baut eine E-Mail, kein Server)
   ========================================================================== */
(function () {
  "use strict";

  var sparsam = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* --------------------------------------------------------- 1. Kopf --- */
  var kopf = document.querySelector(".kopf");
  function beimScrollen() {
    if (!kopf) { return; }
    var y = window.scrollY || window.pageYOffset;
    kopf.setAttribute("data-ab", y > 8 ? "ja" : "nein");
  }
  window.addEventListener("scroll", beimScrollen, { passive: true });
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

    /* Lädt die Seite in einem verborgenen Tab, meldet sich der Beobachter
       nicht. Dann wird nachgeholt, was ohnehin im Bild steht. */
    var nachhelfen = function () {
      Array.prototype.forEach.call(bloecke, function (el) {
        if (el.getBoundingClientRect().top < window.innerHeight) {
          el.setAttribute("data-da", "ja");
        }
      });
    };
    window.setTimeout(nachhelfen, 1400);
    document.addEventListener("visibilitychange", nachhelfen);
  }

  /* ---------------------------------------------------- 3. Leistungen --- */
  /* Ohne JavaScript stehen alle vier Zeichnungen untereinander — erst hier
     wird daraus ein Satz Reiter. */
  var liste = document.getElementById("liste");
  if (liste) {
    var reiter  = [].slice.call(liste.querySelectorAll('[role="tab"]'));
    var blaetter = [].slice.call(document.querySelectorAll(".schau-blatt"));

    var zeigen = function (i, fokus) {
      reiter.forEach(function (r, n) {
        r.setAttribute("aria-selected", n === i ? "true" : "false");
        r.tabIndex = n === i ? 0 : -1;
      });
      blaetter.forEach(function (b, n) { b.hidden = n !== i; });
      if (fokus) { reiter[i].focus(); }
    };

    reiter.forEach(function (r, i) {
      r.addEventListener("click", function () { zeigen(i); });
      r.addEventListener("keydown", function (e) {
        var n = null;
        if (e.key === "ArrowDown" || e.key === "ArrowRight") { n = (i + 1) % reiter.length; }
        if (e.key === "ArrowUp"   || e.key === "ArrowLeft")  { n = (i - 1 + reiter.length) % reiter.length; }
        if (e.key === "Home") { n = 0; }
        if (e.key === "End")  { n = reiter.length - 1; }
        if (n !== null) { e.preventDefault(); zeigen(n, true); }
      });
    });

    zeigen(0);
  }

  /* ----------------------------------------------------- 4. Formular --- */
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
