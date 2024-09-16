edit() {
    if [[ -z "$1" ]]; then
        echo "Please provide a file name"
        return 1
    fi

    local filepath="$1"
    local filename=$(basename "$filepath")
    local dirpath=$(dirname "$filepath")
    local timestamp=$(date +"%Y%m%d%H%M%S")
    local backup_filename="${filename}.${timestamp}"

    # Use the system default editor if set, otherwise fallback to nano
    local editor="${EDITOR:-nano}"

    # Ensure directory path exists
    if [[ ! -d "$dirpath" && "$dirpath" != "." ]]; then
        echo "Directory $dirpath does not exist"
        return 1
    fi

    # Check if file exists, backup if it does
    if [[ -f "$filepath" ]]; then
        # Backup the file before editing
        cp "$filepath" "${dirpath}/${backup_filename}"
        echo "File backed up as: ${dirpath}/${backup_filename}"

        # Clear the contents of the file
        : > "$filepath"
        echo "File $filepath has been cleared."
    else
        echo "File $filepath does not exist. A new file will be created."
        # Create an empty file
        : > "$filepath"
    fi

    # Open the file in the chosen editor
    $editor "$filepath"
}




menu() {
  while true; do
    echo "Please select an option:"
    echo "1) View reboot history"
    echo "2) View iptables status"
    echo "3) Exit menu"
    echo -n "Enter your choice: "

    # Read user input
    read choice

    case $choice in
      1)
        echo "=== Reboot History ==="
        # Use 'last reboot' with pagination for easier viewing on mobile
        last reboot | less
        ;;
      2)
        echo "=== iptables Status ==="
        # Use 'sudo iptables -L' with pagination for easier viewing on mobile
        sudo iptables -L -v -n --line-numbers | less
        ;;
      3)
        echo "Exiting menu..."
        break
        ;;
      *)
        echo "Invalid choice. Please enter a number between 1 and 3."
        ;;
    esac
    echo ""  # New line for better readability
  done
}



replace() {
    # Argument 1: Full file path
    local file_path="$1"
    
    # Argument 2: Search string
    local search="$2"
    
    # Argument 3: Replace string
    local replace="$3"

    # Check if file exists
    if [[ ! -f "$file_path" ]]; then
        echo "Error: File does not exist: $file_path"
        return 1
    fi

    # Check if both search and replace strings are provided
    if [[ -z "$search" || -z "$replace" ]]; then
        echo "Error: Search string and replace string must be provided."
        return 1
    fi

    # Attempt to run the sed replacement, use sudo if needed
    if [[ -w "$file_path" ]]; then
        # If the user has write permissions, replace without sudo
        sed -i'' "s|$search|$replace|g" "$file_path"
    else
        # If the user lacks write permissions, try using sudo
        sudo sed -i'' "s|$search|$replace|g" "$file_path"
    fi

    # Check if the replacement was successful
    if [[ $? -eq 0 ]]; then
        echo "Replaced '$search' with '$replace' in file '$file_path'."
    else
        echo "Error: Failed to replace strings in the file."
    fi
}
