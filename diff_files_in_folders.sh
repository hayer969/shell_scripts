#!/usr/bin/env bash

# How to use: diff_files_in_folders.sh /path/to/one/folder /path/to/another/folder

# Compare all files from one folder with all files from another by bites
# Files in folders should be named equally and their number should match
path_to_folder1=$1
path_to_folder2=$2
# Create arrays with all files from folders
files_folder1=()
files_folder2=()
mapfile -t files_folder1 < <(printf "$(find $path_to_folder1 -iname "*" -type f)")
mapfile -t files_folder2 < <(printf "$(find $path_to_folder2 -iname "*" -type f)")
# Sort files in arrays
IFS=$'\n' sorted_files_1=($(sort <<<"${files_folder1[*]}"))
IFS=$'\n' sorted_files_2=($(sort <<<"${files_folder2[*]}"))
unset IFS
# Check differencies in arrays
diff_files=($(printf "%s\n" "${sorted_files_1[@]#"$path_to_folder1"}" "${sorted_files_2[@]#"$path_to_folder2"}" | sort | uniq -u))
# If there is differencies then print it and quit
if [[ ${#diff_files[@]} -gt 0 ]]
then
    echo "There is files unmatched by name"
    # Find from which folder particular differencies
    for i in "${!diff_files[@]}"
    do
        echo "$(find $path_to_folder1 -path "*${diff_files[$i]}" -type f)"
        echo "$(find $path_to_folder2 -path "*${diff_files[$i]}" -type f)"
    done
    exit 1
fi

echo "Printing byte differencies if any exists..."
for i in "${!sorted_files_1[@]}"
do
    cmp ${sorted_files_1[$i]} ${sorted_files_2[$i]}
done
echo "Done"
exit 0
# printf "%s\n" "${files_folder1[@]}"
