# rbw (unofficial Bitwarden CLI) + a Noctalia launcher picker bound to SUPER+B
{ pkgs, ... }:

let
  # Pick an entry via `noctalia dmenu` and copy its password to the clipboard.
  # The clipboard is cleared after 30s, but only if it still holds the password.
  rbw-pick = pkgs.writeShellApplication {
    name = "rbw-pick";
    runtimeInputs = with pkgs; [
      rbw
      wl-clipboard
      libnotify
    ];
    # noctalia comes from PATH (programs.noctalia)
    text = ''
      rbw unlock || exit 1
      sel=$(rbw list --fields name,user | noctalia dmenu -p "Bitwarden") || exit 0

      tab=$'\t'
      name=''${sel%%"$tab"*}
      user=""
      [[ $sel == *"$tab"* ]] && user=''${sel#*"$tab"}

      pw=$(rbw get "$name" ''${user:+"$user"})
      printf '%s' "$pw" | wl-copy
      notify-send -a rbw "パスワードをコピーしました" "$name''${user:+ ($user)}"

      (
        sleep 30
        [[ "$(wl-paste -n 2>/dev/null)" == "$pw" ]] && wl-copy --clear
      ) &
    '';
  };
in
{
  programs.rbw = {
    enable = true;
    settings = {
      email = "roxas1533@gmail.com";
      pinentry = pkgs.pinentry-qt;
    };
  };

  home.packages = [ rbw-pick ];
}
