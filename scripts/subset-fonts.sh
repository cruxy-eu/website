#!/bin/bash

set -e

SOURCE_FONTS_DIR="./public/fonts"
DIST_FONTS_DIR="./dist/fonts"
DIST_DIR="./dist"
CHARS=' -,:!?.()@*/&#>|0123456789aAbBcCdDeEfFghiIJkKlLmMnNoOpPqrRsStTuUvVwWxyYz'
CHAR_FILE="./dist/fonts/characters.txt"
echo "$CHARS" >> "$CHAR_FILE"

echo "🔤 Starting font subsetting for production..."
echo ""

# Check if dist exists
if [ ! -d "$DIST_DIR" ]; then
    echo "❌ dist/ directory not found. Build the site first!"
    exit 1
fi

# Check if source fonts directory exists
if [ ! -d "$SOURCE_FONTS_DIR" ]; then
    echo "❌ $SOURCE_FONTS_DIR not found!"
    exit 1
fi

# Find all WOFF2 files
FONT_FILES=$(find "$SOURCE_FONTS_DIR" -maxdepth 1 -type f -iname "*.woff2")

if [ -z "$FONT_FILES" ]; then
    echo "⚠️  No WOFF2 fonts found in $SOURCE_FONTS_DIR"
    echo "   Skipping font subsetting."
    exit 0
fi

# Count fonts
FONT_COUNT=$(echo "$FONT_FILES" | wc -l | xargs)
echo "📦 Found $FONT_COUNT font(s) to subset"
echo ""

# Process each font
while read -r font_path; do
    font_name=$(basename "$font_path")
    font_basename="${font_name%.woff2}"
    output_file="$DIST_FONTS_DIR/${font_basename}.woff2"

    echo "📝 Processing $font_name..."

    if [ -n "$CHAR_FILE" ]; then
        # Subset with extracted characters
        pyftsubset "$font_path" \
            --text-file="$CHAR_FILE" \
            --output-file="$output_file" \
            --flavor=woff2 \
            --layout-features='*' \
            --desubroutinize \
            --no-hinting 2>&1 | grep -v "^$" || true
    else
        # Fallback to Latin subset
        pyftsubset "$font_path" \
            --unicodes="$UNICODE_RANGE" \
            --output-file="$output_file" \
            --flavor=woff2 \
            --layout-features='*' \
            --desubroutinize \
            --no-hinting 2>&1 | grep -v "^$" || true
    fi

    if [ -f "$output_file" ]; then
        echo "  ✅ Created $(basename "$output_file")"

        # Show size comparison
        ORIGINAL_SIZE=$(stat -f%z "$font_path" 2>/dev/null || stat -c%s "$font_path" 2>/dev/null || echo "unknown")
        SUBSET_SIZE=$(stat -f%z "$output_file" 2>/dev/null || stat -c%s "$output_file" 2>/dev/null || echo "unknown")

        if [ "$ORIGINAL_SIZE" != "unknown" ] && [ "$SUBSET_SIZE" != "unknown" ]; then
            REDUCTION=$(awk "BEGIN {printf \"%.1f\", (1 - $SUBSET_SIZE/$ORIGINAL_SIZE) * 100}")
            echo "  📊 Size: $(numfmt --to=iec-i --suffix=B $ORIGINAL_SIZE) → $(numfmt --to=iec-i --suffix=B $SUBSET_SIZE) (${REDUCTION}% smaller)"
        fi
    else
        echo "  ❌ Failed to create subset"
    fi

    echo ""

done <<< "$FONT_FILES"

# Clean up temp file
if [ -n "$CHAR_FILE" ]; then
    rm -f "$CHAR_FILE"
fi

# Clean up original WOFF2 files from dist (keep only subsetted versions)
# echo "🧹 Cleaning up..."
# if [ -d "$DIST_FONTS_DIR" ]; then
#     find "$DIST_FONTS_DIR" -maxdepth 1 -type f -iname "*.woff2" ! -iname "*-subset.woff2" -delete
#     echo "  🗑️  Removed original font files from dist"
# fi

echo ""
echo "✨ Font subsetting complete!"
echo ""

# Show final results
if [ -d "$DIST_FONTS_DIR" ]; then
    echo "📊 Optimized fonts in dist/fonts/:"
    ls -lh "$DIST_FONTS_DIR" | grep -E "\.woff2$" | awk '{print "   - " $9 " (" $5 ")"}'
    echo ""
fi
