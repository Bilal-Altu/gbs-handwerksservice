#!/usr/bin/env bash
# Baut die Bilder der GBS-Seite aus den Vorlagen in ../quelle.
#
# Zwei Sorten Vorlagen:
#
#   neu-*.webp   Produktaufnahmen, 768 bis 1125 px breit, sauber belichtet.
#                Sie tragen die Seite — Titel, Lichttafel, Oberflächen.
#   Ziffern.jpg  Aufnahmen eigener Arbeiten von der alten Jimdo-Seite,
#                812 bis 900 px breit, in dunklen Räumen mit dem Handy gemacht.
#                Geprüft am 24.09.2026: teaserbox_* ist dort die größte Fassung,
#                cache_* nur die Anzeigegröße. Mehr gibt es nicht.
#
# Vier Regeln, die erste erzwingt das Skript (es bricht sonst ab):
#
#   1. Jedes Bild wird KLEINER gezeigt, als seine Vorlage breit ist — höchstens
#      0,8×. Ein kleines, gestochenes Bild sieht teuer aus, ein großes weiches
#      billig. Das Seitenlayout ist nach diesen Breiten gebaut, nicht umgekehrt.
#   2. Geschärft wird VOR dem Skalieren, nie danach — sonst entstehen helle
#      Ränder an jeder Kante, die wie Unschärfe aussehen.
#   3. Handyaufnahmen vorher leicht entrauschen, Produktaufnahmen nicht: Bei
#      denen frisst das Entrauschen nur Zeichnung weg.
#   4. Ein Rest Farbe (Sättigung 0,60) hält die Räume bewohnbar. Ganz entfärbt
#      wirkt eine Seite kalt, die Licht und weiße Flächen verkauft.
#
# Reihenfolge: beschneiden → Weißabgleich → (entrauschen) → abstimmen →
#              schärfen → verkleinern.
#
# Aufruf aus dem Ordner gbs/:  bash werkzeug/bilder-bauen.sh
set -e

FF="/c/Users/bilal/AppData/Local/Microsoft/WinGet/Packages/Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe/ffmpeg-9.0.1-full_build/bin/ffmpeg.exe"
Q="$(cd "$(dirname "$0")/.." && pwd)/quelle"
Z="$(cd "$(dirname "$0")/.." && pwd)/assets/img"

# Den Weißabgleich misst man so und rechnet daraus die Kanalfaktoren:
#   ffmpeg -i bild.jpg -vf "crop=…,scale=1:1" -f rawvideo -pix_fmt rgb24 - | od -An -tu1
# Ziel ist, dass die drei Mittelwerte gleich sind.

SCHARF="unsharp=5:5:0.6:5:5:0.0"
RAUSCH="hqdn3d=2:1:3:3"
PRODUKT="eq=contrast=1.05:saturation=0.60:gamma=1.0"
HANDY="eq=contrast=1.08:brightness=0.02:saturation=0.60:gamma=1.02"

# bauen <quelle> <crop> <weissabgleich> <vorbehandlung> <abstimmung> <name> <breite…>
bauen () {
  local src="$1" crop="$2" wb="$3" vor="$4" grade="$5" name="$6"; shift 6
  local breit=${crop#crop=}; breit=${breit%%:*}
  for w in "$@"; do
    if [ "$w" -gt "$breit" ]; then
      echo "  ABBRUCH: $name-$w waere hochgerechnet ($breit px Vorlage)" >&2
      exit 1
    fi
    local vf="$crop,$wb,$vor$grade,$SCHARF,scale=$w:-2:flags=lanczos"
    "$FF" -v error -y -i "$Q/$src" -vf "$vf" -frames:v 1 -q:v 2 "$Z/$name-$w.jpg"
    "$FF" -v error -y -i "$Q/$src" -vf "$vf" -frames:v 1 \
          -c:v libaom-av1 -still-picture 1 -crf 28 -cpu-used 4 "$Z/$name-$w.avif"
    echo "  $name-$w"
  done
}

# ---------------------------------------------------- Produktaufnahmen ----
echo "Titelbild — Wohnraum, Hochglanz (Vorlage 768, gezeigt bei 539)"
bauen neu-wohnraum.webp "crop=768:1000:0:0" \
      "colorchannelmixer=rr=1.076:gg=0.976:bb=0.956" "" \
      "$PRODUKT" titel 700 470

echo "Lichttafel — Bad mit grossem Lichtfeld (Vorlage 1125, gezeigt bei 539)"
bauen neu-bad.webp "crop=1125:1000:0:0" \
      "colorchannelmixer=rr=1.087:gg=0.973:bb=0.951" "" \
      "$PRODUKT" licht 700 470

echo "Oberflaeche — Kinderzimmer, Hochglanz (Vorlage 1125, gezeigt bei 420)"
bauen neu-kinderzimmer.webp "crop=1125:1180:0:120" \
      "colorchannelmixer=rr=1.051:gg=0.995:bb=0.959" "" \
      "$PRODUKT" kind 540 380

echo "Oberflaeche — Kueche mit Lichtrahmen (Vorlage 1024, gezeigt bei 731)"
bauen neu-kueche.webp "crop=1024:700:0:34" \
      "colorchannelmixer=rr=0.986:gg=0.994:bb=1.020" "" \
      "$PRODUKT" flaeche 900 600

# ------------------------------------------------------ Eigene Arbeiten ---
echo "Ausgefuehrt — Kueche, ganzer Raum (Vorlage 812, gezeigt bei 557)"
bauen 2451868915.jpg "crop=812:520:0:460" \
      "colorchannelmixer=rr=0.980:gg=1.014:bb=1.006" "$RAUSCH," \
      "$HANDY" kueche 720 480

echo "Ausgefuehrt — Bad, Hochglanz (Vorlage 520, gezeigt bei 326)"
bauen 2465701607.JPG "crop=520:680:200:70" \
      "colorchannelmixer=rr=1.000:gg=1.019:bb=0.982" "$RAUSCH," \
      "$HANDY" bad 440 300

echo "Ausgefuehrt — Kueche mit Holzplatte (Vorlage 900, gezeigt bei 557)"
bauen 2487208337.jpg "crop=900:320:0:0" \
      "colorchannelmixer=rr=1.029:gg=1.019:bb=0.956" "$RAUSCH," \
      "eq=contrast=1.12:brightness=0.045:saturation=0.60:gamma=1.0" \
      holz 720 480

echo "fertig."
