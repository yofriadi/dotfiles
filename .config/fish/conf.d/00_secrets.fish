# Load local secrets if present (kept out of git).
# Loaded early (00_ prefix) so variables are available to other conf.d scripts.
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end
