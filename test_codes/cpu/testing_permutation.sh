#!/bin/bash
#-------------------------------------------------------------------------------
# Permutation with two duplicates and powers of two taken
#-------------------------------------------------------------------------------
# Define the input array with two replicas
numbers=(1 1 2 3)

# Function to generate permutations while avoiding duplicates
permute () {
    local input=("$@")
    local length=${#input[@]}

    if (( length == 1 )); then
        echo "${input[@]}"
        return
    fi

    local seen=()
    for ((i = 0; i < length; i++)); do
        local num="${input[$i]}"

        #echo $num

        seen+=("$num")


        # Generate sub-permutations
        local rest=("${input[@]:0:i}" "${input[@]:i+1}")
        for sub_perm in $(permute "${rest[@]}"); do
            echo "$num $sub_perm"
        done





    done
}



# Function to map values to powers of two
map_to_powers_of_two() {
    local arr=("$@")
    local result=()
    for val in "${arr[@]}"; do
        # Ensure value is treated as a number and calculate power of two
        power_of_two=$((2 ** val))
        result+=("$power_of_two")
    done
    echo "${result[@]}"
}

# Main execution
echo "Permutations of numbers (${numbers[@]}):"
permutations=$(permute "${numbers[@]}" | sort -u)  # Generate unique permutations

echo "$permutations"

# Process each permutation
echo -e "\nPermutations mapped to powers of two:"
while read -r perm; do
    read -ra arr <<<"$perm" # Convert string to array

    powers=$(map_to_powers_of_two "${arr[@]}")
    echo "Original: $perm -> Powers of Two: $powers"
done <<<"$permutations"

