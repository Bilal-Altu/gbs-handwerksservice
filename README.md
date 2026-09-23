# GBS Handwerksservice — Website-Entwurf

Kostenloser Entwurf für **GBS Handwerksservice, Christian Klein**, In der Hainlache 33,
68642 Bürstadt (Spanndecken, Lichtdecken, Infrarot-Deckenheizung, Innentüren).
Ersatz für die bestehende Jimdo-Seite <https://www.gbs-handwerksservice.de/>.

**Vorschau:** <https://bilal-altu.github.io/gbs-handwerksservice/>

Die Seite steht auf `noindex` und ist per `robots.txt` für Suchmaschinen gesperrt — sie
ist über den Link erreichbar, wird aber nicht gefunden.

---

## Die Gestaltung

Vorbild ist <https://studiograpa.com>. Übernommen ist die Sprache, nicht das Aussehen:

* **Ein durchgehendes warmes Farbfeld** statt Weiß — hier ein Sandton (`#e3d8c8`), bei
  Grapa ein Aprikot. Die ganze Seite ist eine Fläche, ohne Kästen und ohne Abschnitte,
  die sich farblich abwechseln.
* **Winzige Navigation in festen Positionen** quer über die Breite, in Versalien,
  13 Pixel, mit Kommas getrennt. Keine Menüleiste, kein Knopf.
* **Lauftext in großer Serifenschrift** (Newsreader, 20–27 px, Zeilenabstand 1,34) in
  einer schmalen Spalte, die etwa ein Viertel von links eingerückt steht. Daneben eine
  Marginalspalte für die Bezeichnung des Abschnitts.
* **Bilder in unregelmäßigen Breiten und Positionen** — das große Küchenbild läuft
  rechts aus dem Satzspiegel heraus, das kleine Bad steht tiefer und weiter links.
* **Viel Leere.** Zwischen den Bahnen stehen 110 bis 230 Pixel Luft.
* **Erster Schirm:** ein bildfüllendes Foto über die volle Höhe, die Schrift schwebt
  darauf, kein Kasten und kein Balken. Oben die Wege, unten links das Versprechen,
  unten rechts der Weg zum Aufmaß.

Ein Verlauf liegt nur über Kopf und Fuß des ersten Schirms, damit die weiße Schrift
sicher steht; die Mitte mit dem Lichtrahmen bleibt unberührt.

**Schriften:** Newsreader (Lauftext, mager und kursiv) und Instrument Sans (alles
Kleine). Beide selbst ausgeliefert, keine Verbindung zu Google, zusammen 88 KB.

## Aufbau

| | |
|---|---|
| Erster Schirm | Bild über die volle Höhe, Wege, Versprechen |
| Der Aufbau | ein Absatz, Kennwerte in der Randspalte, darunter die große Schnittzeichnung |
| Ausgeführt | zwei Räume, unregelmäßig gesetzt |
| Leistungen | vier Zeilen, daneben zwei kleine Schnitte |
| Fragen | vier Fragen |
| Aufmaß | Anschrift, Wege, Anfragebogen, Partnerzertifikat |

Dazu `impressum.html` und `datenschutz.html` in derselben Sprache.

## Technik

Reines HTML, CSS und etwas JavaScript — kein Framework, kein Build. Hochladen und fertig.

```
index.html · impressum.html · datenschutz.html · favicon.svg · robots.txt
assets/css/gbs.css      alle Stile
assets/js/gbs.js        Leiste, Einblenden, Formular
assets/fonts/*.woff2    Newsreader und Instrument Sans
assets/img/*            AVIF + JPEG, je zwei Größen
werkzeug/bilder-bauen.sh  das Bildrezept
quelle/                 Originalbilder der alten Seite — nicht hochladen
muster/                 frühere Musterentwürfe — nicht hochladen
```

* Ohne JavaScript steht die Seite vollständig da; kommt `gbs.js` nicht an, holt ein
  Sicherungstimer im `<head>` alle Abschnitte nach drei Sekunden zurück.
* Der erste Schirm füllt genau eine Bildschirmhöhe (`100svh`).
* Am Handy bleiben oben nur Wortmarke und Telefonnummer; die Wege kommen mit der
  Leiste, sobald man scrollt.
* Kein waagerechtes Scrollen bei 375, 900, 1440 und 1920 Pixeln Breite.

### Die Zeichnungen

Drei Schnitte als Inline-SVG: Deckenaufbau (Leiste, eingehängte Folie, Maß 3–5 cm,
Einbauspot), Lichtdecke und Deckenheizung. Strichstärken stehen auf
`vector-effect: non-scaling-stroke`. **Achtung beim Weiterbauen:** `.zeichnung .l`
setzt `fill: none` — CSS schlägt das `fill`-Attribut im SVG. Flächen brauchen deshalb
die Klasse `.fl-feld`.

### Das Anfrageformular

Kein Server: Es baut aus den Eingaben eine E-Mail und öffnet das Mailprogramm; schlägt
das fehl, erscheint der Text zum Kopieren. Ohne Telefon oder E-Mail lässt der Browser
die Anfrage nicht abschicken. Für die echte Seite gehört da ein richtiger Versand hin
(kleines PHP-Skript oder ein Dienst wie Formspree, rund eine Stunde Arbeit).

---

## Bilder

Beide Fotos stammen von der bestehenden GBS-Seite, sind hart auf Decke, Kante und Licht
beschnitten, im Weißabgleich neutralisiert und gleich abgestimmt. Rezept in
`werkzeug/bilder-bauen.sh`.

Das bildfüllende Foto im ersten Schirm ist aus demselben Küchenbild geschnitten und auf
1920 Pixel hochgerechnet. Das trägt, weil die Deckenfläche glatt ist und kaum feine
Zeichnung enthält — bei einem detailreichen Motiv würde das nicht funktionieren.

### Was die Seite deutlich besser machen würde

1. **Mehr und bessere Fotos.** Diese Gestaltung lebt vom Bild. Zwei Aufnahmen sind das
   Minimum; mit fünf oder sechs wäre sie eine andere Seite.
2. **Vorher/Nachher-Paare** aus demselben Blickwinkel.
3. **Ein Foto von Christian Klein bei der Montage.**

---

## Vor einem Livegang zu klären

* **„Aufbauhöhe 3–5 cm"** und **„Montage je Raum 1 Tag"** stehen so nicht auf seiner
  alten Seite — Branchenwerte, muss er bestätigen oder korrigieren.
* **Die Bildunterschriften** („matt, Lichtrahmen mit LED" / „Hochglanz, Spots und
  Voute") sind aus den Fotos abgelesen — kurz gegenlesen lassen.
* **Impressum:** Umsatzsteuer-ID (oder Kleinunternehmerregelung), Berufsbezeichnung und
  zuständige Handwerkskammer — im Entwurf markiert.
* **Datenschutz:** Name und Anschrift des Hosters — ebenfalls markiert.
* **WhatsApp:** Die Seite verlinkt `wa.me/491608058213`. Bestätigen, dass die Nummer
  WhatsApp nutzt — sonst den Link entfernen.
* **Zertifikat:** Vor dem Livegang einmal bei CILING abnicken lassen.
* `robots.txt` und die `noindex`-Angaben in allen drei HTML-Dateien entfernen, wenn die
  Seite gefunden werden soll.

## Lokal ansehen

```bash
powershell -NoProfile -ExecutionPolicy Bypass -File ../serve.ps1 -Port 4740
```

Dann <http://localhost:4740/gbs/index.html> öffnen.
