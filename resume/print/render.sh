#!/bin/sh
# Render a résumé HTML file to PDF with headless Chrome, then report page count and,
# for each .page, how far the content reaches versus the bottom margin (CSS px).
#   ./render.sh                       -> resume.html -> deeptanshu-devatha-resume.pdf
#   ./render.sh resume-2page.html out.pdf
set -e
cd "$(dirname "$0")"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
SRC="${1:-resume.html}"
OUT="${2:-$PWD/deeptanshu-devatha-resume.pdf}"
case "$OUT" in /*) ;; *) OUT="$PWD/$OUT" ;; esac
"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
  --run-all-compositor-stages-before-draw --virtual-time-budget=4000 \
  --print-to-pdf="$OUT" "file://$PWD/$SRC" 2>/dev/null
pdfinfo "$OUT" | grep -E 'Pages|Page size'
"$CHROME" --headless=new --disable-gpu --virtual-time-budget=4000 --window-size=816,2400 --dump-dom \
  "file://$PWD/$SRC" 2>/dev/null | grep -o 'data-h="[^"]*"' || true
