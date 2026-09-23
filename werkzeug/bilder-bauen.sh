#!/usr/bin/env bash
# Baut die Bilder der GBS-Seite aus den Originalen in ../quelle.
#
# Rezept: hart auf Decke, Kante und Licht beschneiden, Weißabgleich
# neutralisieren, dann alle Bilder gleich ruhig abstimmen. Ausgabe je Motiv
# in zwei Größen, als AVIF und als JPEG zum Rückfall.
#
# Aufruf aus dem Ordner gbs/:  bash werkzeug/bilder-bauen.sh
set -e

FF="/c/Users/bilal/AppData/Local/Microsoft/WinGet/Packages/Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe/ffmpeg-9.0.1-full_build/bin/ffmpeg.exe"
Q="$(cd "$(dirname "$0")/.." && pwd)/quelle"
Z="$(cd "$(dirname "$0")/.." && pwd)/assets/img"

# gemeinsame Abstimmung: etwas mehr Zeichnung, deutlich weniger Farbe
GRADE="eq=contrast=1.07:brightness=0.014:saturation=0.78:gamma=1.02"

# Den Weißabgleich misst man so und rechnet daraus die Kanalfaktoren:
#   ffmpeg -i bild.jpg -vf "crop=…,scale=1:1" -f rawvideo -pix_fmt rgb24 - | od -An -tu1
# Ziel ist, dass die drei Mittelwerte gleich sind.

bauen () {   # $1 Quelle  $2 Ziel  $3 crop  $4 Kanalkorrektur  $5 gross  $6 klein
  for b in "$5" "$6"; do
    vf="$3,$4,$GRADE,scale=$b:-2:flags=lanczos,unsharp=5:5:0.45:5:5:0"
    "$FF" -v error -y -i "$Q/$1" -vf "$vf" -q:v 2 "$Z/$2-$b.jpg"
    "$FF" -v error -y -i "$Q/$1" -vf "$vf" -c:v libaom-av1 -still-picture 1 \
          -crf 30 -cpu-used 6 -pix_fmt yuv420p "$Z/$2-$b.avif"
    echo "$2-$b"
  done
}

# Küche: nur Decke, Lichtrahmen und der obere Rand des Raums
bauen 2451868915.jpg decke-kueche "crop=812:470:0:40" \
  "colorchannelmixer=rr=0.980:gg=1.014:bb=1.007" 812 480

# Bad: Hochglanzdecke, LED-Streifen, Spiegelschrank — ohne Wanne, Fliesen, Pflanze
bauen 2465701607.JPG decke-bad "crop=442:480:275:35" \
  "colorchannelmixer=rr=1.000:gg=1.011:bb=0.989" 442 320

# Innentür: ohne Stühle, Tisch und Teppich
bauen 2487208284.jpg tuer "crop=430:760:150:60" \
  "colorchannelmixer=rr=0.977:gg=1.002:bb=1.023" 430 320

# Zertifikat bleibt ein Dokument — nur verkleinert, ohne Abstimmung
for b in 520 300; do
  "$FF" -v error -y -i "$Q/2448639631.jpg" -vf "scale=$b:-2:flags=lanczos" -q:v 2 \
        "$Z/zertifikat-$b.jpg"
  "$FF" -v error -y -i "$Q/2448639631.jpg" -vf "scale=$b:-2:flags=lanczos" \
        -c:v libaom-av1 -still-picture 1 -crf 30 -cpu-used 6 -pix_fmt yuv420p \
        "$Z/zertifikat-$b.avif"
  echo "zertifikat-$b"
done
