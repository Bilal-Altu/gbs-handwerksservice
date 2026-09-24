#!/usr/bin/env bash
# Baut die Bilder der GBS-Seite aus den Originalen in ../quelle.
#
# Die Originale sind klein — 812 bis 900 Pixel breit, mehr gibt die alte Seite
# nicht her (geprüft am 24.09.2026: die Jimdo-Adressen teaserbox_* sind die
# größten, cache_* ist nur die Anzeigegröße). Deshalb gilt hier:
#
#   1. NICHT hochrechnen. Jedes Bild wird höchstens in seiner eigenen
#      Ausschnittsbreite ausgeliefert, lieber kleiner.
#   2. Geschärft wird VOR dem Skalieren, nie danach — sonst entstehen helle
#      Ränder an jeder Kante, die wie Unschärfe aussehen.
#   3. Vorher einmal leicht entrauschen: Die Aufnahmen sind in dunklen Räumen
#      entstanden, und der harte Kontrast danach würde das Korn mitziehen.
#
# Reihenfolge: beschneiden → Weißabgleich → entrauschen → abstimmen →
#              schärfen → skalieren.
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
SCHARF="unsharp=5:5:0.8:5:5:0.0"

# bauen <quelle> <crop> <weissabgleich> <abstimmung> <name> <breite…>
bauen () {
  local src="$1" crop="$2" wb="$3" grade="$4" name="$5"; shift 5
  local breit=${crop#crop=}; breit=${breit%%:*}
  for w in "$@"; do
    if [ "$w" -gt "$breit" ]; then
      echo "  ABBRUCH: $name-$w wäre hochgerechnet ($breit px Vorlage)" >&2
      exit 1
    fi
    local vf="$crop,$wb,$RAUSCH,$grade,$SCHARF,scale=$w:-2:flags=lanczos"
    "$FF" -v error -y -i "$Q/$src" -vf "$vf" -frames:v 1 -q:v 2 "$Z/$name-$w.jpg"
    "$FF" -v error -y -i "$Q/$src" -vf "$vf" -frames:v 1 \
          -c:v libaom-av1 -still-picture 1 -crf 30 -cpu-used 6 "$Z/$name-$w.avif"
    echo "  $name-$w"
  done
}

WEICH="eq=contrast=1.16:saturation=0.12:gamma=0.98"                  # helle Motive
HART="eq=contrast=1.20:brightness=-0.055:saturation=0.10:gamma=0.92" # dunkle Motive

echo "Titelbild — Küchendecke mit Lichtrahmen (Vorlage 812)"
bauen 2451868915.jpg "crop=812:372:0:150" \
      "colorchannelmixer=rr=0.974:gg=1.017:bb=1.009" \
      "eq=contrast=1.22:brightness=0.120:saturation=0.11:gamma=1.0" \
      titel 812 560

echo "Lichtdecke — Flur, Produktaufnahme CILING (Vorlage 900)"
bauen 2487208287.jpg "crop=900:470:0:20" \
      "colorchannelmixer=rr=1.047:gg=1.038:bb=0.925" \
      "$HART" licht 900 620

echo "Küche — ganzer Raum (Vorlage 812)"
bauen 2451868915.jpg "crop=812:520:0:460" \
      "colorchannelmixer=rr=0.980:gg=1.014:bb=1.006" \
      "$WEICH" kueche 812 560

echo "Bad — Hochglanz (Vorlage 520)"
bauen 2465701607.JPG "crop=520:680:200:70" \
      "colorchannelmixer=rr=1.000:gg=1.019:bb=0.982" \
      "$WEICH" bad 520 380

echo "Küche mit Holzplatte — Deckenfeld (Vorlage 900)"
bauen 2487208337.jpg "crop=900:320:0:0" \
      "colorchannelmixer=rr=1.029:gg=1.019:bb=0.956" \
      "eq=contrast=1.24:brightness=0.022:saturation=0.10:gamma=0.97" \
      holz 900 620

echo "fertig."
