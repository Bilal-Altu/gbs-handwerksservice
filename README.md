# GBS Handwerksservice — Website-Entwurf

Kostenloser Entwurf für **GBS Handwerksservice, Christian Klein**, In der Hainlache 33,
68642 Bürstadt (Spanndecken, Lichtdecken, Infrarot-Deckenheizung, Innentüren).
Ersatz für die bestehende Jimdo-Seite <https://www.gbs-handwerksservice.de/>.

**Vorschau:** <https://bilal-altu.github.io/gbs-handwerksservice/>

Die Seite steht auf `noindex` und ist per `robots.txt` für Suchmaschinen gesperrt — sie
ist über den Link erreichbar, wird aber nicht gefunden.

---

## Die Gestaltung

Vorbild ist <https://www.genesis.ai>. Übernommen ist die Sprache, nicht das Aussehen:

* **Weißes Blatt, darauf Tafeln.** Jeder Abschnitt ist eine eigene Fläche mit 16 px
  runden Ecken, vom Blattrand eingerückt. Dazwischen bleibt Weiß stehen.
* **Messstriche und Maschinenschrift in den Ecken.** Oben und unten an jeder Tafel
  läuft eine Reihe feiner Striche, dazwischen steht links, worum es geht, und rechts
  ein Wert: `01 — Der Aufbau` / `3–5 cm unter der alten Decke`. Bei Genesis sind das
  Laufzeiten, hier sind es Maße — das passt zu einem Betrieb, der Räume aufmisst.
* **Kleine Schrift, große Bilder.** Fließtext 15–17 px, Beschriftungen 11 px; die
  Wirkung kommt aus den Aufnahmen und aus der Leere, nicht aus dem Schriftgrad.
* **Fast entfärbte Bilder.** Alle Fotos sind auf Restfarbe heruntergezogen, hart
  abgestimmt und gleich hell. Aus Handyfotos werden so Architekturaufnahmen.
* **Zwei dunkle Tafeln** setzen den Rhythmus: „Licht, das keine Lampe ist" und das
  Aufmaß am Ende.
* **Knöpfe** sind klein, 6 px rund, in Maschinenschrift — kein Marketing-Balken.

**Farben:** Weiß `#ffffff`, Tafel `#f1f2f1`, Tinte `#111417`, Grau `#656a6e`,
Linie `#dde2e4`, dunkle Tafel `#14171a`. Keine Schmuckfarbe. Jede Paarung ist
nachgerechnet: Grau auf der Tafel 4,9:1, alles andere darüber.

**Schriften:** Instrument Sans (alles Laufende) und Geist Mono 500 (alle Werte,
Beschriftungen und Knöpfe). Beide selbst ausgeliefert, keine Verbindung zu Google,
zusammen 51 KB.

## Aufbau

| | |
|---|---|
| Titeltafel | Bild über die ganze Tafel, Versprechen, zwei Knöpfe |
| 01 Der Aufbau | ein Absatz, vier Kennwerte, darunter die große Schnittzeichnung |
| 02 Lichtdecke | dunkle Tafel, Aussage links, Aufnahme rechts |
| 03 Leistungen | vier Posten; wer einen anklickt, sieht die passende Zeichnung |
| 04 Ausgeführt | drei Räume mit Datenzeile |
| 05 Fragen | vier Fragen, zweispaltig |
| 06 Aufmaß | dunkle Tafel: Anfragebogen, Wege, Anschrift, Partnerzertifikat |

Dazu `impressum.html` und `datenschutz.html` in derselben Sprache.

## Technik

Reines HTML, CSS und etwas JavaScript — kein Framework, kein Build. Hochladen und fertig.

```
index.html · impressum.html · datenschutz.html · favicon.svg · robots.txt
assets/css/gbs.css      alle Stile
assets/js/gbs.js        Kopfleiste, Einblenden, Reiter, Formular
assets/fonts/*.woff2    Instrument Sans und Geist Mono
assets/img/*            AVIF + JPEG, je zwei Größen
werkzeug/bilder-bauen.sh  das Bildrezept
quelle/                 Originalbilder der alten Seite — nicht hochladen
muster/                 frühere Musterentwürfe — nicht hochladen
```

* Ohne JavaScript steht die Seite vollständig da: Die vier Zeichnungen der Leistungen
  stehen dann untereinander statt hinter Reitern, und kommt `gbs.js` gar nicht an,
  holt ein Sicherungstimer im `<head>` alle Abschnitte nach drei Sekunden zurück.
* Die Reiter der Leistungen sind ein richtiges `tablist` — mit Pfeiltasten, Home und
  End bedienbar.
* Die Titeltafel füllt genau eine Bildschirmhöhe (`100svh`), höchstens aber 880 px.
* **Am Handy steht der Satz nicht mehr auf dem Bild**, sondern darunter: Hochkant ist zu
  wenig Bild übrig, um Schrift sicher darauf zu legen. Die Tafel ordnet sich dafür per
  `order` neu.
* Kein waagerechtes Scrollen bei 375, 700, 980, 1440 und 1920 Pixeln Breite.

### Die Zeichnungen

Vier Schnitte als Inline-SVG: Deckenaufbau, Spanndecke, Lichtdecke, Deckenheizung und
der Grundriss einer Innentür. Strichstärken stehen auf `vector-effect:
non-scaling-stroke`, damit sie in jeder Größe gleich fein bleiben.

**Zwei Fallen beim Weiterbauen:**

1. `.zeichnung .l` setzt `fill: none` — CSS schlägt das `fill`-Attribut im SVG.
   Flächen brauchen deshalb die Klasse `.fl-feld`.
2. Die Beschriftung steht in Zeichnungseinheiten, wird also mit der Zeichnung kleiner.
   Am Handy ist sie deshalb per Media Query größer gesetzt — und das weiße Feld hinter
   der längsten Beschriftung muss dort mitwachsen (`.feld-lang`).

### Das Anfrageformular

Kein Server: Es baut aus den Eingaben eine E-Mail und öffnet das Mailprogramm; schlägt
das fehl, erscheint der Text zum Kopieren. Ohne Telefon oder E-Mail lässt der Browser
die Anfrage nicht abschicken. Für die echte Seite gehört da ein richtiger Versand hin
(kleines PHP-Skript oder ein Dienst wie Formspree, rund eine Stunde Arbeit).

---

## Bilder

Alle Aufnahmen stammen von der bestehenden GBS-Seite. Rezept in
`werkzeug/bilder-bauen.sh`: beschneiden, Weißabgleich messen und neutralisieren, auf
Restfarbe herunterziehen, hart abstimmen, dann AVIF und JPEG in zwei Größen.

| Bild | Motiv | Herkunft |
|---|---|---|
| `titel` | Küchendecke mit Lichtrahmen | eigene Arbeit |
| `kueche` | dieselbe Küche, ganzer Raum | eigene Arbeit |
| `bad` | Hochglanzdecke, LED über dem Spiegelschrank | eigene Arbeit |
| `holz` | Küche mit Essplatz, Lichtfeld | eigene Arbeit |
| `licht` | Flur mit großer Lichtdecke | **Produktaufnahme CILING** |
| `zertifikat` | Partnerurkunde | CILING |

Das Flurbild ist als Produktaufnahme gekennzeichnet — in der Ecke der Tafel steht
„Produktaufnahme CILING". Das Wasserzeichen ist weggeschnitten, deshalb muss die
Kennzeichnung stehen bleiben.

### Was die Seite deutlich besser machen würde

1. **Mehr und bessere Fotos.** Diese Gestaltung lebt vom Bild. Vier eigene Aufnahmen
   sind das Minimum; mit acht wäre sie eine andere Seite.
2. **Vorher/Nachher-Paare** aus demselben Blickwinkel.
3. **Ein Foto von Christian Klein bei der Montage.**

---

## Vor einem Livegang zu klären

* **„Aufbauhöhe 3–5 cm"** und **„Montage je Raum 1 Tag"** stehen so nicht auf seiner
  alten Seite — Branchenwerte, muss er bestätigen oder korrigieren.
* **Die Bildunterschriften** („matt, Lichtrahmen" / „Hochglanz" / „Satin, Lichtfeld")
  sind aus den Fotos abgelesen — kurz gegenlesen lassen. Auch, ob alle drei Räume
  wirklich seine Arbeiten sind.
* **Das Flurbild und das Zertifikat** gehören CILING. Vor dem Livegang einmal abnicken
  lassen — oder das Flurbild gegen eine eigene Lichtdecke tauschen.
* **Impressum:** Umsatzsteuer-ID (oder Kleinunternehmerregelung), Berufsbezeichnung und
  zuständige Handwerkskammer — im Entwurf markiert.
* **Datenschutz:** Name und Anschrift des Hosters — ebenfalls markiert.
* **WhatsApp:** Die Seite verlinkt `wa.me/491608058213`. Bestätigen, dass die Nummer
  WhatsApp nutzt — sonst den Link entfernen.
* `robots.txt` und die `noindex`-Angaben in allen drei HTML-Dateien entfernen, wenn die
  Seite gefunden werden soll.

## Lokal ansehen

```bash
powershell -NoProfile -ExecutionPolicy Bypass -File ../serve.ps1 -Port 4740
```

Dann <http://localhost:4740/gbs/index.html> öffnen.
