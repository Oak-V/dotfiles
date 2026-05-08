local keys=$(ggl)

export GPG_DEFAULT_AUTH_SUBKEY=$(echo "$keys" | sed -n '/\[A\]/,/Keygrip/p'| awk '/Keygrip/ {print $3}')
export GPG_DEFAULT_SIGN_SUBKEY=$(echo "$keys" | sed -n '/\[S\]/,+1p' | awk '/^[[:space:]]+[0-9A-F]{40}/ {print $1}')
export GPG_DEFAULT_ENCR_SUBKEY=$(echo "$keys" | sed -n '/\[E\]/,+1p' | awk '/^[[:space:]]+[0-9A-F]{40}/ {print $1}')

export GPG_DEFAULT_KIND="ed25519"
export GPG_DEFAULT_EXPI="1y"

echo "[user]
        name = ${GPG_GIVENAME} ${GPG_SURNAME}
        email = ${GPG_EMAIL}
        signingkey = ${GPG_SIGN_SUBKEY:-$GPG_DEFAULT_SIGN_SUBKEY}" > $HOME/.secret.gitconfig
