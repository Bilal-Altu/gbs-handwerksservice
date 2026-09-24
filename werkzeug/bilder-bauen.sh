#!/usr/bin/env bash
# Baut die Bilder der GBS-Seite aus den Originalen in ../quelle.
#
# Die Originale sind klein — 812 bis 900 Pixel breit, mehr gibt die alte Seite
# nicht her (geprüft am 24.09.2026: die Jimdo-Adressen teaserbox_* sind die
# größten, cache_* ist nur die Anzeigegröße). Deshalb gilt hier:
#
#   1. Jedes Bild wird KLEINER gezeigt, als seine Vorlage breit ist — höchstens
#      0,8×. Ein kleines, gestochenes Bild sieht teuer aus, ein großes weiches
#      billig. Das Seitenlayout ist nach diesen Breiten gebaut, nicht umgekehrt.
#   2. Geschärft wird VOR dem Skalieren, nie danach — sonst entstehen helle
#      Ränder an jeder Kante, die wie Unschärfe aussehen.
#   3. Vorher einmal leicht entrauschen: Die Aufnahmen sind in dunklen Räumen
#      entstanden, und der Kontrast danach würde das Korn mitziehen.
#   4. Ruhig abstimmen statt hart. Viel Kontrast frisst auf weichen Vorlagen die
#      letzte Zeichnung; ein Rest Farbe hält die Räume bewohnbar.
#
# Reihenfolge: beschneiden → Weißabgleich → entrauschen → abstimmen →
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

RAUSCH="hqdn3d=2:1:3:3"
SCHARF="unsharp=5:5:0.6:5:5:0.0"
RUHIG="eq=contrast=1.08:brightness=0.02:saturation=0.18:gamma=1.02"

# bauen <quelle> <crop> <weissabgleich> <abstimmung> <name> <breite…>
bauen () {
  local src="$1" crop="$2" wb="$3" grade="$4" name="$5"; shift 5
  local breit=${crop#crop=}; breit=${breit%%:*}
  for w in "$@"; do
    if [ "$w" -gt "$breit" ]; then
      echo "  ABBRUCH: $name-$w waere hochgerechnet ($breit px Vorlage)" >&2
      exit 1
    fi
    local vf="$crop,$wb,$RAUSCH,$grade,$SCHARF,scale=$w:-2:flags=lanczos"
    "$FF" -v error -y -i "$Q/$src" -vf "$vf" -frames:v 1 -q:v 2 "$Z/$name-$w.jpg"
    "$FF" -v error -y -i "$Q/$src" -vf "$vf" -frames:v 1 \
          -c:v libaom-av1 -still-picture 1 -crf 28 -cpu-used 4 "$Z/$name-$w.avif"
    echo "  $name-$w"
  done
}

echo "Titelbild — Kueche hochkant (Vorlage 700, gezeigt bei 570)"
bauen 2451868915.jpg "crop=700:930:56:120" \
      "colorchannelmixer=rr=0.984:gg=1.024:bb=0.999" \
      "eq=contrast=1.10:brightness=0.05:saturation=0.18:gamma=1.03" \
      titel 700 470

echo "Lichtdecke — Flur, Produktaufnahme CILING (Vorlage 900, gezeigt bei 570)"
bauen 2487208287.jpg "crop=900:470:0:20" \
      "colorchannelmixer=rr=1.047:gg=1.038:bb=0.925" \
      "eq=contrast=1.10:brightness=-0.035:saturation=0.14:gamma=0.96" \
      licht 720 480

echo "Kueche — ganzer Raum (Vorlage 812, gezeigt bei 570)"
bauen 2451868915.jpg "crop=812:520:0:460" \
      "colorchannelmixer=rr=0.980:gg=1.014:bb=1.006" \
      "$RUHIG" kueche 720 480

echo "Bad — Hochglanz (Vorlage 520, gezeigt bei 333)"
bauen 2465701607.JPG "crop=520:680:200:70" \
      "colorchannelmixer=rr=1.000:gg=1.019:bb=0.982" \
      "$RUHIG" bad 440 300

echo "Kueche mit Holzplatte — Deckenfeld (Vorlage 900, gezeigt bei 570)"
bauen 2487208337.jpg "crop=900:320:0:0" \
      "colorchannelmixer=rr=1.029:gg=1.019:bb=0.956" \
      "eq=contrast=1.12:brightness=0.045:saturation=0.16:gamma=1.0" \
      holz 720 480

echo "fertig."
