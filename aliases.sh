# ngrok-related aliases

# get the first ngrok url
alias ngurl="curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'"

# get the first ngrok url and copy it to the clipboard
alias ngcp="ngurl | xclip -sel clip"

# postgresql-related aliases

alias pgl="psql --host=localhost"


