{ ... }:
{
  home.file.xkb_config = {
    source = ./src;
    target = ".config/xkb";
    recursive = true;
  };
}
