runoncepath("os").
runoncepath("test_loop").

set main_os to initialize_os().
main_os["log"]("OS initialized.").

init_my_test_loop(main_os).

main_os["log"]("Program loaded").

set os_result to main_os["run"]().

main_os["log"]("OS execution halted with code " + os_result + ".").
