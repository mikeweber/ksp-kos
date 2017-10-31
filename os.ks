declare function initialize_os {
  declare local modes to list().
  declare local log_cooldown to 1.
  declare local log_last to time:seconds - log_cooldown.
  declare local log_queue to queue().

  declare local function add_mode {
    declare parameter mode.
    modes:add(mode).
  }

  declare local function log {
    declare parameter msg.
    declare parameter cooldown is log_cooldown.
    if (time:seconds < log_last + cooldown) return.

    set log_last to time:seconds.
    log_queue:push(msg).
  }

  declare local function flush_log {
    declare local iter_queue to log_queue:iterator.
    until not iter_queue:next {
      print iter_queue:value.
    }
    log_queue:clear().
  }

  declare local function run {
    declare parameter initial_mode is 0.
    set current_mode to initial_mode.

    until false {
      if (current_mode >= modes:length) return 0. // All steps complete

      set result to modes[current_mode]().
      if (result < 0) return result. // Reserved for exceptions
      if (result > 0) set current_mode to current_mode + 1. // Current mode completed
      flush_log().
      wait 0.0.
    }
  }

  return lexicon(
    "add_mode", add_mode@,
    "flush_log", flush_log@,
    "log", log@,
    "run", run@
  ).
}
