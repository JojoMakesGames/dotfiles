
#!/bin/bash

if [ $# -eq 1 ]; then
    path="$1"
else
    echo "Error: Please provide a valid path as a parameter."
    exit 1
fi

tmux new-window bash -c "cd $HOME/teamsnap/$path/ && nvim"
tmux rename-window "$path"
