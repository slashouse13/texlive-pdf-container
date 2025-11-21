#!/usr/bin/env bash

FILE_PATH=$1
TEXLIVE_SOURCE_URL=${TEXLIVE_SOURCE_URL:-"https://mirror.ctan.org"}

set -e

if [[ -z "$FILE_PATH" ]]; then
    echo "Usage: $0 <path-to-latex-file>"
    exit 1
fi

FILE_NAME=${FILE_PATH##*/}

echo "Building and running LaTeX file: $FILE_NAME"
IMAGE=${IMAGE:-ghcr.io/slashouse13/texlive-full:1.0}

docker build --build-arg TEXLIVE_SOURCE_URL=$TEXLIVE_SOURCE_URL -t $IMAGE .

echo "Running LaTeX compilation in Docker container..."
docker run --rm -v "$FILE_PATH":/tex/$FILE_NAME -v ./:/tex $IMAGE $FILE_NAME
echo "Created PDF: ${FILE_NAME%.tex}.pdf"

echo "Cleaning up auxiliary files..."
rm -f "${FILE_NAME%.tex}.aux" "${FILE_NAME%.tex}.log" "${FILE_NAME%.tex}.out" "${FILE_NAME%.tex}.tex"
echo "Done."