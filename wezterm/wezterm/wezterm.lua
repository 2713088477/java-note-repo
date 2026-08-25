-- 引入 wezterm API
local wezterm = require("wezterm")

-- 创建配置构建器
local config = wezterm.config_builder()

-- 字体配置优化
config.font = wezterm.font_with_fallback({
    "JetBrains Mono",
    "Fira Code", 
    "Noto Color Emoji"
})
 
-- 设置 Git Bash 为默认终端
-- 注意：路径中使用了双反斜杠 \\ 进行转义
-- --login -i 参数确保 Bash 以交互式登录模式启动，这样你的 .bashrc 等环境变量才会正常加载
config.default_prog = { "F:\\git\\Git\\bin\\bash.exe", "--login", "-i" }

config.keys = {
  -- 将 Ctrl+C 绑定为复制到系统剪贴板
  {
    key = "c",
    mods = "CTRL",
    action = wezterm.action.CopyTo("Clipboard"),
  },
  -- 将 Ctrl+V 绑定为从系统剪贴板粘贴
  {
    key = "v",
    mods = "CTRL",
    action = wezterm.action.PasteFrom("Clipboard"),
  },
}

-- 返回配置
return config