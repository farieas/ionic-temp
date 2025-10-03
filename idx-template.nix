{ pkgs, ... }: {
  channel = "stable-25.05";
  packages = [ pkgs.nodejs_20 ];
  bootstrap = ''
    npx --prefer-offline -y @ionic/cli start "$WS_NAME" blank --type=angular --no-deps --no-git --no-link --no-interactive
    mkdir -p "$WS_NAME"/.idx
    cp ${./dev.nix} "$WS_NAME"/.idx/dev.nix
    mv "$WS_NAME" "$out"
    chmod -R u+w "$out"
    (cd "$out"; npm install --package-lock-only --ignore-scripts)
  '';
}
