# ngrok-related aliases

# get the first ngrok url
alias ngurl="curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'"

# get the first ngrok url and copy it to the clipboard
alias ngcp="ngurl | xclip -sel clip"

# postgresql-related aliases

alias pgl="psql --host=localhost"

# start dev ics container

alias dev-ics="/home/art/dev/voyage/docker-dev/run.sh --ics --nvidia --host --priv"

# switch to cockpit-apps dev
alias cdca="cd ~/dev/voyage/cockpit-apps"

# switch to commander dev
alias cdcdr="cd ~/dev/voyage/commander"


