{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.browsers;
in
{
  options.modules.browsers = {
    enable = mkEnableOption "Browser applications";

    enableBrave = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Brave browser";
    };

    enableQutebrowser = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Qutebrowser";
    };
  };

  config = mkIf cfg.enable {
    programs.brave.enable = cfg.enableBrave;

    programs.qutebrowser = mkIf cfg.enableQutebrowser {
      enable = true;
      settings = {
        auto_save.interval = 0;
        content.blocking.enabled = true;
        content.blocking.method = "both";
        content.blocking.adblock.lists = [
          "https://easylist.to/easylist/easylist.txt"
          "https://easylist.to/easylist/easyprivacy.txt"
          "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=1&mimetype=plaintext"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2020.txt"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/legacy.txt"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt"
          "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"
          "https://easylist.to/easylist/fanboy-annoyance.txt"
          "https://secure.fanboy.co.nz/fanboy-annoyance.txt"
          "https://easylist-downloads.adblockplus.org/liste_fr.txt"
          "https://easylist-downloads.adblockplus.org/ruadlist.txt"
          "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
        ];
        content.blocking.hosts.lists = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
        content.private_browsing = true;
        colors.webpage.preferred_color_scheme = "dark";
        colors.webpage.darkmode.enabled = true;
        colors.webpage.darkmode.algorithm = "lightness-hsl";
      };

      extraConfig = ''
        c.url.searchengines = {
          'DEFAULT' : "https://start.duckduckgo.com/?q={}",
          'map' : "https://www.google.com/maps/?q={}",
          'eba' : "https://www.ebay.com/sch/i.html?_nkw={}",
          'yt' : "https://youtube.com/results?search_query={}",
          'aur' : "https://aur.archlinux.org/packages/?K={}",
          'arch' : "https://www.archlinux.org/packages/?q={}",
          'wiki' : "https://en.wikipedia.org/w/index.php?search={}",
          'ldlc' : "https://www.ldlc.com/navigation/{}",
          'git' : "https://github.com/search?q={}",
          'steam' : "https://store.steampowered.com/search/?term={}",
          'deal' : "https://www.dealabs.com/search?q={}",
          'protondb' : "https://www.protondb.com/search?q={}",
          'archwiki' : "https://wiki.archlinux.org/index.php?search={}",
          'xda' : "https://forum.xda-developers.com/search/?query={}",
          'reddit' : "https://www.reddit.com/search?q={}&sort=relevance&t=all",
          'subreddit' : "https://www.reddit.com/r/{}",
          'trend' : "https://trends.google.com/trends/explore?q={}",
          'stack' : "https://stackoverflow.com/search?q={}",
          'firefoxadd' : "https://addons.mozilla.org/en/firefox/search/?q={}",
          'imdb' : "https://www.imdb.com/find?ref_=nv_sr_fn&q={}&s=all",
        }
      '';
    };
  };
}
