#!/bin/bash
# Build the arXiv source package from the current sources.
#
#   ./make_arxiv.sh   ->   arxiv_submission.tar.gz
#
# Two things arXiv needs that a normal local build does not:
#
#   1. arXiv does not run BibTeX, so arxiv.bbl must be shipped.
#   2. bmvc2k_natbib.sty is a renamed copy of natbib.sty. arXiv strips bundled
#      duplicates of standard packages, so that file disappears on their side and
#      bmvc2k.cls then fails to load it. The class copy in the package is patched
#      to use the system natbib instead; output is identical (verified by diffing
#      the rendered text against a build with the bundled 8.1 copy).
#
# The project's own bmvc2k.cls is never modified: only the copy inside the
# package is patched, so the BMVC camera-ready keeps the official class.

set -e
cd "$(dirname "$0")"

PKG=arxiv_pkg
TARBALL=arxiv_submission.tar.gz

echo "==> building arxiv.pdf so .bbl and .fls are current"
latexmk -pdf -interaction=nonstopmode arxiv >/dev/null

echo "==> assembling $PKG"
rm -rf "$PKG" "$TARBALL"
mkdir -p "$PKG"

cp arxiv.tex arxiv.bbl bmvc2k.cls bmvc2k.bst "$PKG"/

# Use the system natbib instead of the bundled renamed copy (see note above).
sed -i '' 's/\\usepackage\[sort,numbers\]{bmvc2k_natbib}/\\usepackage[sort,numbers]{natbib}/' "$PKG/bmvc2k.cls"
grep -q 'usepackage\[sort,numbers\]{natbib}' "$PKG/bmvc2k.cls" || { echo "natbib patch failed"; exit 1; }

for f in introduction related_work dataset models_section experiments \
         experimental_setup evaluation_metrics results uncertainty_analysis \
         discussion conclusion supplementary; do
  cp "$f.tex" "$PKG"/
done

# Only the figures the build actually loads, with their relative paths.
# arXiv warns above 34 megapixels and may time out, so anything past 20 MP is
# capped at 3200 px on its longest side. Every figure here is placed at most
# 5 inches wide, so 3200 px is still ~640 dpi and nothing visible is lost.
grep -aoE "^INPUT \./.*\.(png|jpg|jpeg|pdf|eps)" arxiv.fls | sed 's|^INPUT \./||' | sort -u \
  | while read -r p; do
      mkdir -p "$PKG/$(dirname "$p")"
      cp "$p" "$PKG/$p"
      case "$p" in
        *.png|*.jpg|*.jpeg|*.PNG|*.JPG|*.JPEG)
          px=$(sips -g pixelWidth -g pixelHeight "$p" 2>/dev/null \
               | awk '/pixelWidth/{w=$2}/pixelHeight/{h=$2}END{print w*h}')
          if [ -n "$px" ] && [ "$px" -gt 20000000 ]; then
            echo "    downsampling $p ($((px/1000000)) MP) to 3200 px"
            sips -Z 3200 "$PKG/$p" >/dev/null
          fi
          ;;
      esac
    done

echo "==> verifying the package compiles standalone, pdflatex only, no bibtex"
( cd "$PKG" && pdflatex -interaction=nonstopmode arxiv >/dev/null 2>&1 \
              && pdflatex -interaction=nonstopmode arxiv >/dev/null 2>&1 )
grep -aq "Output written" "$PKG/arxiv.log" || { echo "standalone build FAILED"; exit 1; }
if grep -aqi "undefined" "$PKG/arxiv.log"; then echo "WARNING: undefined references in package build"; fi
echo "    $(grep -a 'Output written' "$PKG/arxiv.log")"

( cd "$PKG" && rm -f arxiv.aux arxiv.log arxiv.out arxiv.pdf arxiv.fls arxiv.fdb_latexmk arxiv.synctex.gz )

# No leading "./" on the archive entries. COPYFILE_DISABLE keeps macOS from
# writing AppleDouble "._name" resource-fork companions into the archive, which
# arXiv strips one by one and complains about.
( cd "$PKG" && COPYFILE_DISABLE=1 tar czf "../$TARBALL" -- * )

echo "==> $TARBALL  ($(du -h "$TARBALL" | cut -f1), $(tar tzf "$TARBALL" | grep -vc '/$') files)"
