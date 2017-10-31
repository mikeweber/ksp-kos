declare function init_my_test_loop {
  parameter os.

  declare local current_mode to 0.
  declare local test1_current to 0.
  declare local test2_timestamp to 0.

  declare local function test1 {
    set test1_current to test1_current + 1.
    os["log"]("current is " + test1_current, 0).
    if (test1_current > 10) return 1.

    return 0.
  }

  declare local function test2 {
    if (test2_timestamp = 0) {
      set test2_timestamp to time:seconds.
      os["log"]("Waiting until " + (test2_timestamp + 5) + ".", 0).
    }
    if (time:seconds > test2_timestamp + 5) return 1.

    os["log"](time:seconds).
    return 0.
  }

  declare local loop to list(
    test1@,
    test2@
  ).

  declare local function run {
    if (run_current_mode() > 0) return 1.

    return 0.
  }

  declare local function run_current_mode {
    if (current_mode >= loop:length()) return 1.
    if (loop[current_mode]() > 0) increment_mode().

    return 0.
  }

  declare local function increment_mode {
    set current_mode to current_mode + 1.
  }

  os["add_mode"](run@).
}
