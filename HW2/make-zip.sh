#!/bin/bash
# Rebuilds HW2_SohailHareshGidwani.zip from the HW2_SohailHareshGidwani/ folder.
#
# The screenshots live only in that folder. The READMEs and the SQL files live
# here in HW2/ and get copied in first, so the folder and the zip always match
# what is in the repo.
set -euo pipefail
cd "$(dirname "$0")"

name=HW2_SohailHareshGidwani

screenshots=(
    1-loan/kimi-prompt.png
    1-loan/tidb-run.png
    2-licenses/kimi-prompt.png
    2-licenses/tidb-run.png
    2-licenses/tidb-run-12-month-watchlist.png
    3-procedures/kimi-prompt.png
    3-procedures/tidb-run.png
    3-procedures/tidb-run-by-type.png
    4-insurance/kimi-prompt.png
    4-insurance/tidb-run.png
    4-insurance/tidb-run-patients-per-company.png
    4-insurance/tidb-run-companies-not-used.png
    5-upcoming-visits/kimi-prompt.png
    5-upcoming-visits/tidb-run.png
    5-upcoming-visits/tidb-run-by-month.png
    setup/kimi-prompt-0-description.png
    setup/kimi-prompt-0b-create-tables.png
    setup/tidb-create-tables.png
    setup/tidb-insert-data.png
)
for f in "${screenshots[@]}"; do
    [[ -f "$name/$f" ]] || { echo "missing screenshot: $name/$f" >&2; exit 1; }
done

cp README.txt "$name/README.txt"
cp sql/01-schema.sql sql/02-seed-data.sql sql/03-kimi-queries.sql "$name/setup/"

# README.md here links to HW2_SohailHareshGidwani/... and sql/...; inside the
# folder those same files are just ... and setup/...
perl -pe "s/\]\($name\//](/g; s/\]\(sql\//](setup\//g" README.md > "$name/README.md"

rm -f "$name.zip"
zip -rqX "$name.zip" "$name" -x '*.DS_Store'
unzip -l "$name.zip"
