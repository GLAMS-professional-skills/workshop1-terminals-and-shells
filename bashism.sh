#!/bin/bash

# Don't touch this function
writestuff() {
    echo "output"
    echo "error" >&2
}

writestuff &> stdout_and_stderr.txt # file created should contain "output" and "error"

# sh doesn't have arithmetic, but the `expr` executable can deal with this
result=$((10 + 5))
echo "Arithmetic result of 10 + 5: $result"

sleep 1

message="Hello "
read -p "Enter your name: " name
message+=$name
echo $message

sleep 1

# The square bracket syntax is shorthand for using the `test` executable
[[ -d "/tmp" ]] && echo "/tmp exists and is a directory."

sleep 1

# bonus points for still using `nl` but adding a colon after the number of the ingredient
(nl | while read line; do
	echo "ingredient $line"
done) <<EOF
carrots
tomatoes
onions
EOF

