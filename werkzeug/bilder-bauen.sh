#!/usr/bin/env bash
# Baut die Bilder der GBS-Seite aus den Originalen in ../quelle.
#
# Rezept: hart auf Decke, Kante und Licht beschneiden, Weißabgleich
# neutralisieren, dann fast entfärben und hart abstimmen — die Seite zeigt
# Räume wie Architekturaufnahmen, nicht wie Handyfotos. Ausgabe je Motiv in
# zwei Größen, als AVIF und als JPEG zum Rückfall.
#
# Aufruf aus dem Ordner gbs/:  bash werkzeug/bilder-bauen.sh
set -e

FF="/c/Users/bilal/AppData/Local/Microsoft/WinGet/Packages/Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe/ffmpeg-9.0.1-full_build/bin/ffmpeg.exe"
Q="$(cd "$(dirname "$0")/.." && pwd)/quelle"
Z="$(cd "$(dirname "$0")/.." && pwd)/assets/img"

# Den Weißabgleich misst man so und rechnet daraus die Kanalfaktoren:
#   ffmpeg -i bild.jpg -vf "crop=…,scale=1:1" -f rawvideo -pix_fmt rgb24 - | od -An -tu1
# Ziel ist, dass die drei Mittelwerte gleich sind.

# bauen <quelle> <crop> <weissabgleich> <abstimmung> <name> <breite1> <breite2>
bauen () {
  local src="$1" crop="$2" wb="$3" grade="$4" name="$5"; shift 5
  for w in "$@"; do
    local vf="$crop,$wb,$grade,scale=$w:-2:flags=lanczos,unsharp=5:5:0.5:5:5:0"
    "$FF" -v error -y -i "$Q/$src" -vf "$vf" -frames:v 1 -q:v 3 "$Z/$name-$w.jpg"
    "$FF" -v error -y -i "$Q/$src" -vf "$vf" -frames:v 1 \
          -c:v libaom-av1 -still-picture 1 -crf 32 -cpu-used 6 "$Z/$name-$w.avif"
    echo "  $name-$w"
  done
}

WEICH="eq=contrast=1.16:saturation=0.12:gamma=0.98"   # helle Motive
HART="eq=contrast=1.20:brightness=-0.055:saturation=0.10:gamma=0.92"  # dunkle Motive

echo "Titelbild — Küchendecke mit Lichtrahmen"
bauen 2451868915.jpg "crop=812:372:0:150" \
      "colorchannelmixer=rr=0.974:gg=1.017:bb=1.009" \
      "eq=contrast=1.22:brightness=0.120:saturation=0.11:gamma=1.0" \
      titel 1200 1800

echo "Lichtdecke — Flur (Produktaufnahme CILING)"
bauen 2487208287.jpg "crop=900:470:0:20" \
      "colorchannelmixer=rr=1.047:gg=1.038:bb=0.925" \
      "$HART" licht 900 1400

echo "Küche — ganzer Raum"
bauen 2451868915.jpg "crop=812:520:0:460" \
      "colorchannelmixer=rr=0.980:gg=1.014:bb=1.006" \
      "$WEICH" kueche 820 1200

echo "Bad — Hochglanz"
bauen 2465701607.JPG "crop=520:540:200:70" \
      "colorchannelmixer=rr=0.992:gg=1.015:bb=0.992" \
      "$WEICH" bad 640 900

echo "Küche mit Holzplatte — Deckenfeld"
bauen 2487208337.jpg "crop=900:320:0:0" \
      "colorchannelmixer=rr=1.029:gg=1.019:bb=0.956" \
      "eq=contrast=1.24:brightness=0.022:saturation=0.10:gamma=0.97" \
      holz 900 1400

echo "fertig."
