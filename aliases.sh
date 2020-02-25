alias ngurl="curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'"
alias ngcp="ngurl | xclip -sel clip"

