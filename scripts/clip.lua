mp.options = require "mp.options"

-- Options
--
-- directory: Specifies where to save clips.
--
local options = {
  directory = "~/Desktop"
}

-- Read options.
mp.options.read_options(options)
options.directory = mp.command_native({ "expand-path", options.directory })

-- Logs a message on the screen and to the terminal
-- with the given severity level ("info" by default).
local function log(message, level)
  level = level or "info"
  mp.osd_message(message)
  mp.msg.log(level, message)
end

-- Returns `true` if `path` exists else returns `false`.
local function file_exists(path)
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  else
    return false
  end
end

-- Returns the dot and extension of the currently played file,
-- or an empty string if it has no extension.
--
-- Example: ".webm" for "clip.webm"
--
local function get_file_dot_extension()
  local filename = mp.get_property("filename")
  local filename_no_ext = mp.get_property("filename/no-ext")
  return filename:sub(#filename_no_ext + 1)
end

-- Creates a clip out of the currently played video using A-B loop points.
-- The clip will be saved on your desktop with the following command.
--
-- ffmpeg -ss <a-point> -i <input> -to <b-point> -map 0 -c copy -- <output>
--
-- See [Seeking] for details.
--
-- [Seeking]: https://trac.ffmpeg.org/wiki/Seeking
--
local function create()
  local start_time = mp.get_property_native("ab-loop-a")
  local end_time = mp.get_property_native("ab-loop-b")

  -- Abort if A-B loop is not set.
  if start_time == "no" or end_time == "no" then
    log("A-B loop must be set", "error")
    return
  end

  -- Set input and output files.
  local input = mp.get_property("path")
  local file_stem = mp.command_native({ "expand-text", "${filename/no-ext}_${ab-loop-a}_${ab-loop-b}" })
  local file_dot_extension = get_file_dot_extension()
  if file_dot_extension == "" then
    file_dot_extension = ".webm"
  end
  local output = options.directory .. "/" .. file_stem .. file_dot_extension

  -- Abort if file exists.
  if file_exists(output) then
    log("Can’t save clip, file '" .. output .. "' already exists!", "error")
    return
  end

  -- Shell command to create the clip.
  local args = { "ffmpeg", "-ss", tostring(start_time), "-i", input, "-to", tostring(end_time - start_time), "-map", "0", "-c", "copy", "--", output }

  -- Start processing the clip.
  log("Processing clip: " .. output)
  mp.msg.info(table.concat(args, " "))
  local result = mp.command_native({ name = "subprocess", args = args, capture_stdout = true, capture_stderr = true })

  -- Show result.
  if result.status == 0 then
    log("Clip complete: " .. output)
    mp.msg.verbose(result.stdout, result.stderr)
  else
    log("Clip failed: " .. output, "error")
    mp.msg.error(result.stdout, result.stderr)
  end
end

-- Key bindings
mp.add_key_binding("c", "create", create)
