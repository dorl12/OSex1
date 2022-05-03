#!/bin/bash
# Dor Levy 313547085

if [ "$1" == "" ]  || [ "$2" == "" ]
then
  echo "Not enough parameters"
  exit 0
fi

cd "$1"

if [ "$3" == "-r" ]
then
  # shellcheck disable=SC2044
  for FILE in $(find ./ -type f)
  do
    if [[ "$FILE" == *.out ]]
    then
      rm "$FILE";
    fi
  done
  # shellcheck disable=SC2044
  for FILE in $(find ./ -type f)
  do
    if [[ "$FILE" == *.c ]] && grep -q -i -w "$2" "$FILE"
    then
      gcc -w -g3 -o3 "$FILE" -o "${FILE%.c}".out;
    fi
  done
else
  for FILE in *;
  do
    if [[ "$FILE" == *.out ]]
    then
      rm "$FILE";
    fi
  done

  for FILE in *;
  do
    if [[ "$FILE" == *.c ]] && grep -i -w "$2" "$FILE"
    then
      gcc -w -o "$(basename "$FILE" ".c").out" "$FILE";
    fi
  done
fi

#for FILE in *;
#do
#  if [[ "$FILE" == *.out ]]
#  then
#    rm "$FILE";
#  fi
#done
#
#for FILE in *;
#do
#  if [[ "$FILE" == *.c ]] && grep -q "$2" "$FILE"
#  then
#    gcc -w -o "$(basename "$FILE" ".c").out" "$FILE";
#  fi
#done

#if [ "$3" == "-r" ]
#then
#  # shellcheck disable=SC2038
#  find ./ -name '*.out' | xargs rm
#  # shellcheck disable=SC2038
#  find ./ -name '*.c' && grep -q "$2" "$FILE" | xargs rm
#fi

## shellcheck disable=SC2044
#for FILE in $(find ./ -type f)
#do
#  if [[ "$FILE" == *.out ]]
#  then
#    rm "$FILE";
#  fi
#done
#
## shellcheck disable=SC2044
#for FILE in $(find ./ -type f)
#do
#  if [[ "$FILE" == *.c ]] && grep -q "$2" "$FILE"
#  then
#    gcc -w -o "$(basename "$FILE" ".c").out" "$FILE";
#  fi
#done

