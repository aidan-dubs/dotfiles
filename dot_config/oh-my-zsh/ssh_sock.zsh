# Use Bitwarden's SSH agent socket only when no valid agent is already set.
bitwarden_sock="$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
if [[ -S "$bitwarden_sock" ]]; then
    if [[ -z "${SSH_CONNECTION-}${SSH_CLIENT-}${SSH_TTY-}" ]]; then
        export SSH_AUTH_SOCK="$bitwarden_sock"
    fi
fi
