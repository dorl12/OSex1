#!/bin/bash
# Dor Levy 313547085

if [ "$1" == "" ] || [ "$2" == "" ]; then
  echo "Not enough parameters"
  exit 0
fi

cd "$1"

if [ "$3" == "-r" ]; then
  # shellcheck disable=SC2044
  for FILE in $(find ./ -type f); do
    if [[ "$FILE" == *.out ]]; then
      rm "$FILE"
    fi
  done
  # shellcheck disable=SC2044
  for FILE in $(find ./ -type f); do
    if [[ "$FILE" == *.c ]] && grep -q -i -w "$2" "$FILE"; then
      gcc -w -o "${FILE%.c}".out "$FILE"
    fi
  done
else
  for FILE in *; do
    if [[ "$FILE" == *.out ]]; then
      rm "$FILE"
    fi
  done

  for FILE in *; do
    if [[ "$FILE" == *.c ]] && grep -q -i -w "$2" "$FILE"; then
      gcc -w -o "$(basename "$FILE" ".c").out" "$FILE"
    fi
  done
fi
