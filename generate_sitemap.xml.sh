#!/usr/bin/env bash
set -euo pipefail

SITE_URL="https://www.goncharov.xyz"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INDEX_OUTPUT="${SCRIPT_DIR}/sitemap-index.xml"

{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'

  while IFS= read -r -d '' file; do
    filename="$(basename "$file")"

    if [[ "$filename" = "README.md" ]]; then
      continue
    fi

    # Build URL path: strip leading ./ and .md extension
    rel="${file#"${SCRIPT_DIR}/"}"
    url_path="/${rel%.md}"

    # Get last commit date for this file (ISO 8601), fallback to file mtime
    lastmod="$(git -C "$SCRIPT_DIR" log -1 --format="%aI" -- "$file" 2>/dev/null || true)"
    if [[ -z "$lastmod" ]]; then
      lastmod="$(date -r "$file" +"%Y-%m-%dT%H:%M:%S%z" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S%z")"
    fi
    # Normalize to date only for cleaner output
    lastmod="${lastmod:0:10}"

    echo "  <url>"
    echo "    <loc>${SITE_URL}${url_path}</loc>"
    echo "    <lastmod>${lastmod}</lastmod>"
    echo "    <changefreq>monthly</changefreq>"
    echo "  </url>"

  done < <(find "$SCRIPT_DIR" \
    -not -path "*/.git/*" \
    -not -path "*/assets/*" \
    -not -path "*/_layouts/*" \
    -name "*.md" \
    -print0 | sort -z)

  echo '</urlset>'
} > "$INDEX_OUTPUT"


echo "Entries: $(grep -c '<loc>' "$INDEX_OUTPUT")"
echo "Generated: $INDEX_OUTPUT"
