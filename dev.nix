# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-25.05"; # or "unstable"
  
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.nodejs_24
    pkgs.git
  ];
  
  # Sets environment variables in the workspace
  env = {
    # Ensure npm global packages are in PATH
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    PATH = "$HOME/.npm-global/bin:$PATH";
  };
  
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "angular.ng-template"
      "ionic.ionic"
    ];
    
    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        # Install Ionic CLI globally
        install-ionic = "npm install -g @ionic/cli";
        # Install project dependencies
        npm-install = "npm ci --no-audit --prefer-offline --no-progress --timing || npm i --no-audit --no-progress --timing";
        # Open editors for the following files by default, if they exist:
        default.openFiles = [ "src/app/app.component.ts" ];
      };
      
      # To run something each time the workspace is (re)started, use the `onStart` hook
      onStart = {
        # Ensure Ionic CLI is available on restart
        ensure-ionic = "command -v ionic > /dev/null || npm install -g @ionic/cli";
      };
    };
    
    # Enable previews and customize configuration
    previews = {
      enable = true;
      previews = {
        web = {
          # Use ionic serve instead of npm start for better development experience
          command = ["ionic" "serve" "--port" "$PORT" "--host" "0.0.0.0" "--no-open"];
          manager = "web";
        };
      };
    };
  };
}
