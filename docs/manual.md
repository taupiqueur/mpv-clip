# Manual

## Usage

Press `l` to set [A-B loop points], then `c` to create the clip.

[A-B loop points]: https://mpv.io/manual/master/#command-interface-ab-loop

The clip will be saved on your desktop with the following command.

```
ffmpeg -ss <a-point> -i <input> -to <b-point> -map 0 -c copy -- <output>
```

See [Seeking] for details.

[Seeking]: https://trac.ffmpeg.org/wiki/Seeking

After processing the clip, a notification will appear on the screen,
with a detailed message in the terminal and the [console].

[Console]: https://mpv.io/manual/master/#console

## Key-bindings

###### create

Creates a clip out of the currently played video using [A-B loop points].

[A-B loop points]: https://mpv.io/manual/master/#command-interface-ab-loop

Default is `c`.

## Options

###### directory

Specifies where to save clips.

Default is `~/Desktop`.
