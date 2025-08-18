{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font Mono";
      size = 14.0;
    };

    settings = {
      scrollback_lines = 8000;
      paste_actions = "quote-urls-at-prompt";
      strip_trailing_spaces = "never";
      select_by_word_characters = "@-./_~?&=%+#";
      remember_window_size = "yes";
      initial_window_width = "35c";
      initial_window_height = "120c";
      enabled_layouts = "splits,stack,fat,tall,grid";
      window_resize_step_cells = 2;
      window_resize_step_lines = 2;
      window_border_width = "0.5pt";
      visual_window_select_characters = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      confirm_os_window_close = -1;
      tab_bar_style = "powerline";
      background_opacity = "1.0";
      background_image = "none";
      background_image_layout = "tiled";
      background_image_linear = "no";
      dynamic_background_opacity = "yes";
      allow_remote_control = "yes";
      listen_on = "none";
      allow_hyperlinks = "yes";
      shell_integration = "enabled";
      term = "xterm-256color";
      kitty_mod = "ctrl+shift";
    };
        keybindings = {
    "ctrl+a>x" = "close_window";
    "ctrl+a>]" = "next_window";
    "ctrl+a>[" = "previous_window";
    "ctrl+a>." = "move_window_forward";
    "ctrl+a>," = "move_window_backward";
    "ctrl+a>c" = "launch --cwd=last_reported --type=tab";
    "ctrl+a>," = "set_tab_title";
    "ctrl+equal" = "change_font_size all +2.0";
    "ctrl+plus" = "change_font_size all +2.0";
    "ctrl+kp_add" = "change_font_size all +2.0";
    "ctrl+minus" = "change_font_size all -2.0";
    "ctrl+kp_subtract" = "change_font_size all -2.0";
    "ctrl+0" = "change_font_size all 0";
    "f11" = "toggle_fullscreen";
    "ctrl+a>e" = "launch --type=tab nvim ~/.config/kitty/kitty.conf";
    "ctrl+a>r" = "combine : load_config_file : launch --type=overlay --hold --allow-remote-control kitty @ send-text \"kitty config reloaded\"";
    "ctrl+a>d" = "debug_config";
    "ctrl+a>space" = "kitten hints --alphabet asdfqwerzxcvjklmiuopghtybn1234567890 --customize-processing ${./custom-hints.py}";
    "f3" = "kitten hints --program '*'";
    "ctrl+a>ctrl+a" = "send_text all \\x01";
  };

        # 键盘映射
    keybindings = {
      "ctrl+a>x" = "close_window";
      "ctrl+a>]" = "next_window";
      "ctrl+a>[" = "previous_window";
      "ctrl+a>." = "move_window_forward";
      "ctrl+a>," = "move_window_backward";
      "ctrl+a>c" = "launch --cwd=last_reported --type=tab";
      "ctrl+a>," = "set_tab_title";
      "ctrl+equal" = "change_font_size all +2.0";
      "ctrl+plus" = "change_font_size all +2.0";
      "ctrl+kp_add" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+kp_subtract" = "change_font_size all -2.0";
      "ctrl+0" = "change_font_size all 0";
      "f11" = "toggle_fullscreen";
      "ctrl+a>e" = "launch --type=tab nvim ~/.config/kitty/kitty.conf";
      "ctrl+a>r" = "combine : load_config_file : launch --type=overlay --hold --allow-remote-control kitty @ send-text \"kitty config reloaded\"";
      "ctrl+a>d" = "debug_config";
      "ctrl+a>space" = "kitten hints --alphabet asdfqwerzxcvjklmiuopghtybn1234567890";
      "f3" = "kitten hints --program '*'";
      "ctrl+a>ctrl+a" = "send_text all \\x01";
    };

        # 额外配置（鼠标、布局、主题等）
    extraConfig = ''
      # 鼠标配置
      mouse_map left click ungrabbed no-op
      mouse_map ctrl+left click ungrabbed mouse_handle_click selection link prompt
      mouse_map ctrl+left press ungrabbed mouse_selection normal
      mouse_map right press ungrabbed copy_to_clipboard
      
      # 标签页标题模板
      tab_title_template "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{index}:{'🇿' if layout_name == 'stack' and num_windows > 1 else ''}{title}"
      
      # 布局配置
      layout splits {
        split_axis = vertical
        split_size = 50
        screen_split_axis = vertical
        
        top {
          split_axis = horizontal
          split_size = 50
          children = [ left_top right_top ]
        }
        
        bottom {
          split_axis = horizontal
          split_size = 50
          children = [ left_bottom right_bottom ]
        }
      }
      
      # 会话配置
      new_tab ${pkgs.fish}/bin/fish
      launch --type=tab --cwd=current ${pkgs.fish}/bin/fish
      launch --type=window --cwd=current ${pkgs.tmux}/bin/tmux
    '';
  };
  
  # 确保所有依赖项可用
  home.packages = with pkgs; [
    kitty
    fish
    tmux
    nvim
  ];
  
  # 创建启动脚本
  home.file.".local/bin/kitty-session" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      ${pkgs.kitty}/bin/kitty --session ${config.xdg.configHome}/kitty/kitty.conf
    '';
    executable = true;
  };
}
