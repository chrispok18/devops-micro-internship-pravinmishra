#!/bin/bash

full_name="Christian Aryee"

tools=("bash" "nano" "chmod" "echo" "ls" "pwd")

echo "Full Name: $full_name"
echo "Bash Tools Checklist:"
echo "----------------------"

for tool in "${tools[@]}"
do
    echo "Tool available for practice: $tool"
done


