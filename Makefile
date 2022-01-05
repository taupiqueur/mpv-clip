build:

install:
	install -d ~/.config/mpv/scripts
	install scripts/clip.lua ~/.config/mpv/scripts

uninstall:
	rm -f ~/.config/mpv/scripts/clip.lua
