# GBS Handwerksservice — Entwurf „Werkstattblatt"

Kostenloser Entwurf für **GBS Handwerksservice, Christian Klein**, In der Hainlache 33,
68642 Bürstadt (Spanndecken, Lichtdecken, Infrarot-Deckenheizung, Innentüren).
Ersatz für die bestehende Jimdo-Seite <https://www.gbs-handwerksservice.de/>.

`noindex` und per `robots.txt` gesperrt — eine Vorschau, keine veröffentlichte Seite.

---

## Das Konzept

Die Seite ist kein Prospekt, sondern ein **Satz technischer Blätter**. Jedes Blatt hat
eine Kopfzeile mit Titel und Blattnummer, einen Inhalt und eine Fußzeile mit Quelle
oder Hinweis. Die Blätter liegen auf einem leicht dunkleren Untergrund, als lägen sie
auf einem Tisch.

Das trägt aus zwei Gründen: Eine Spanndecke ist ein technisches Produkt mit echten
Kennwerten — die will man sehen, nicht in Werbetexte verpackt bekommen. Und die Form
ist unverwechselbar. Niemand sonst in der Branche macht das.

**Was bewusst fehlt** — und zwar, weil genau diese Bausteine jede Seite nach Vorlage
aussehen lassen: keine vier Nutzenkacheln unter dem Auftakt, keine vier
Leistungskarten im Raster, keine Drei-Schritte-Grafik, kein Akkordeon, keine Pillen,
keine Icon-Listen. Die Inhalte sind alle da — sie stehen nur in Tabellen, Schnitten
und Randnotizen.

**Schrift:** Instrument Sans für alles, Instrument Serif kursiv nur für Randnotizen —
wie mit der Hand an die Zeichnung geschrieben. Beide selbst ausgeliefert, keine
Verbindung zu Google.

**Farbe:** Papier `#f8f7f4` auf Tisch `#e8e4db`, Tusche `#191917`, zwei Grautöne, drei
Linienstärken. Das Logoviolett erscheint als dunkles Aubergine nur in den Quadraten
der Wortmarke und beim Zeigen auf Knöpfe.

> Zwei verworfene Fassungen liegen dazwischen: eine dunkle mit Violett-Schimmer und
> Lichtregler („wirkt extrem billig") und eine helle, redaktionelle („zu langweilig,
> zu sehr nach KI-Seite"). Die Mustervarianten des zweiten Anlaufs stehen in
> `muster/` — A Werkstattblatt, B Vollbild, C Plakat. Der Ordner kann weg.

## Die Blätter

| Blatt | Inhalt | Warum so |
|-------|--------|----------|
| 01 | Regeldetail Wandanschluss, volle Bildschirmhöhe | Briefkopf, vier Kennwerte und Telefon links; rechts die Aussage und die große Schnittzeichnung |
| 02 | Ausgeführte Arbeiten | Zwei Räume mit je einer Kennungszeile — Dokumentation statt Galerie. Die Spaltenbreiten (1,88 zu 1) sind so gewählt, dass Quer- und Hochformat gleich hoch stehen |
| 03 | Was wir machen | Die vier Leistungen als Spezifikationstabelle, daneben zwei Schnitte |
| 04 | Warum nicht spachteln · Nachweis | Vergleichstabelle und Partnerzertifikat auf einem Blatt |
| 05 | Aufmaß anfragen | Briefkopf und Formular wie ein Anfragebogen |
| 06 | Fragen | Sechs echte Telefonfragen, zweispaltig gesetzt wie ein Anhang |

Eine erste Fassung hatte sieben Blätter und auf jedem eine Tabelle — „bisschen too
much". Gestrichen wurden das Inhaltsverzeichnis in der linken Spalte, zwei der sechs
Kennwerte auf Blatt 01, die Werkstofftabelle und die Datenzeilen unter den Fotos, das
eigene Zertifikatsblatt sowie zwei Fragen. Die Seite ist dadurch von 4.600 auf rund
3.400 Pixel Höhe geschrumpft.

Dazu `impressum.html` (Anhang A) und `datenschutz.html` (Anhang B) in derselben Sprache.

## Technik

Reines HTML, CSS und etwas JavaScript — kein Framework, kein Build. Hochladen und fertig.

```
index.html · impressum.html · datenschutz.html · favicon.svg · robots.txt
assets/css/gbs.css      alle Stile
assets/js/gbs.js        Leiste, Einblenden, Formular
assets/fonts/*.woff2    Instrument Sans und Serif, selbst ausgeliefert
assets/img/*            AVIF + JPEG, je zwei Größen
werkzeug/bilder-bauen.sh  das Bildrezept
quelle/                 Originalbilder der alten Seite — nicht hochladen
muster/                 die drei Musterentwürfe — nicht hochladen
```

* Ohne JavaScript steht die Seite vollständig da; kommt `gbs.js` nicht an, holt ein
  Sicherungstimer im `<head>` alle Abschnitte nach drei Sekunden zurück.
* Blatt 01 passt vollständig in einen Bildschirm (geprüft bei 1440 × 860).
* Am Handy kommen auf Blatt 01 erst Aussage und Zeichnung, dann Briefkopf und Daten;
  die Kopfleiste steht dort dauerhaft. Unten eine Leiste „Anrufen / WhatsApp".
* Die beiden breiten Tabellen laufen am Handy seitlich, mit Hinweis.

### Die Zeichnungen

Drei Schnitte als Inline-SVG in einer Sprache: Bestandsdecke und Wände schraffiert,
Spanndecke als kräftige Linie, Beschriftung klein.

1. **Deckenaufbau** — Leiste an der Wand, eingehängte Folie, Maß 3–5 cm, Einbauspot
2. **Lichtdecke** — LED hinter der Folie, gleichmäßiger Lichtaustritt
3. **Deckenheizung** — Heizfolie über der Decke, Strahlungswärme nach unten

Strichstärken stehen auf `vector-effect: non-scaling-stroke`, damit sie in jeder Größe
gleich fein bleiben. **Achtung beim Weiterbauen:** `.zeichnung .l` setzt `fill: none` —
CSS schlägt das `fill`-Attribut im SVG. Flächen brauchen deshalb die Klasse
`.fl-blatt` oder ein eigenes Rechteck darunter.

### Das Anfrageformular

Kein Server: Es baut aus den Eingaben eine E-Mail und öffnet das Mailprogramm; schlägt
das fehl, erscheint der Text zum Kopieren. Ohne Telefon oder E-Mail lässt der Browser
die Anfrage nicht abschicken. Für die echte Seite gehört da ein richtiger Versand hin
(kleines PHP-Skript oder ein Dienst wie Formspree, rund eine Stunde Arbeit).

---

## Bilder

Beide Fotos stammen von der bestehenden GBS-Seite, sind hart auf Decke, Kante und
Licht beschnitten, im Weißabgleich neutralisiert und gleich abgestimmt. Rezept in
`werkzeug/bilder-bauen.sh` — für neue Aufnahmen die Zuschnitte anpassen, der Rest
bleibt.

Nicht übernommen: die Infrarot-Grafik mit den roten Pfeilen, der blaue Flur mit
CILING-Wasserzeichen, der Systemrender, das dritte Küchenfoto und die Türabbildung —
zu schwach oder zu katalogartig für diese Gestaltung. Die Türen stehen jetzt nur noch
in der Leistungstabelle.

### Was die Seite deutlich besser machen würde

1. **Vorher/Nachher-Paare.** Das eine Element, das in dieser Branche am meisten
   verkauft. Zwei oder drei Paare aus demselben Blickwinkel reichen — und sie passen
   perfekt in die Blattlogik von Blatt 02.
2. **Mehr ausgeführte Räume.** Momentan tragen zwei Fotos das ganze Blatt 02.
3. **Ein Foto von Christian Klein bei der Montage.**
4. **Google-Bewertungen**, falls es ein Unternehmensprofil gibt.

---

## Vor einem Livegang zu klären

* **Aufbauhöhe „3–5 cm typ."** steht nirgends auf seiner alten Seite — das ist ein
  Branchenwert und muss von Christian Klein bestätigt oder korrigiert werden.
  Dasselbe gilt für „Montage je Raum: 1 Tag" (seine Seite sagt nur „wenige Stunden").
* **Die Kennungen auf Blatt 02** („matt, Lichtrahmen mit LED" / „Hochglanz, Spots und
  Voute") sind aus den Fotos abgelesen — kurz gegenlesen lassen.
* **Impressum:** Umsatzsteuer-ID (oder Kleinunternehmerregelung), Berufsbezeichnung
  und zuständige Handwerkskammer — im Entwurf gelb markiert.
* **Datenschutz:** Name und Anschrift des Hosters — ebenfalls gelb markiert.
* **WhatsApp:** Die Seite verlinkt `wa.me/491608058213`. Bestätigen, dass die Nummer
  WhatsApp nutzt — sonst den Link entfernen.
* **Zertifikat:** Vor dem Livegang einmal bei CILING abnicken lassen.
* **Hinweis:** Die alte Seite schreibt an einer Stelle „Schweizer Präzisionsarbeit /
  SWISSMADE", an anderer „in Deutschland gefertigt" — und das Partnerzertifikat trägt
  „Made in Germany". Der Entwurf sagt durchgehend Deutschland.
* `robots.txt` und die `noindex`-Angaben in allen drei HTML-Dateien entfernen, wenn die
  Seite gefunden werden soll.

## Lokal ansehen

```bash
powershell -NoProfile -ExecutionPolicy Bypass -File ../serve.ps1 -Port 4740
```

Dann <http://localhost:4740/gbs/index.html> öffnen.
