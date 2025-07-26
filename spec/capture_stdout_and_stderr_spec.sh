
script_under_test="bin/capture_stdout_and_stderr.sh"

# Verify that:
#   - the named variable to capture stdout is populated
#   - the named variable to capture stderr is populated
#   - exit status is 0
# TODO will eventually need to check that
#   - stdout and stderr is captured into variables (done)
#   - each variable contains the expected value
#   - the return status is the expected value
Describe "capture_stdout_and_stderr"
  Include "${script_under_test}"
  It "the named capture variables should be populated with the expected values"
    When call capture_stdout_and_stderr stdout_capture stderr_capture simple_function_hello_goodbye_7
    The variable stdout_capture should be present
    The variable stderr_capture should be present
    The status should equal 0
  End
  It "the named capture variables should be populated with the expected values"
    When call capture_stdout_and_stderr foovar barvar simple_function_hello_goodbye_7
    The variable foovar should be present
    The variable barvar should be present
    The status should equal 0
  End
End

Describe "capture_stdout_and_stderr_help"
  Include "${script_under_test}"
  It "outputs help info"
    When call capture_stdout_and_stderr_help
    The stdout should include "capture_stdout_and_stderr"
    The stdout should include "Version 0.3.0"
    The stdout should include "For usage information call: capture_stdout_and_stderr_help_usage"
    The status should equal 0
  End
End

Describe "capture_stdout_and_stderr_help_usage"
  Include "${script_under_test}"
  It "outputs usage info"
    When call capture_stdout_and_stderr_help_usage
    The stdout should include "capture_stdout_and_stderr"
    The stdout should include "Usage"
    The status should equal 0
  End
End

simple_function_hello_goodbye_7()
  # outputs "hello" to stdout, "goodbye" to stderr, and sets exit status to 7
{
  printf "hello"
  printf "goodbye" >&2
  return 7
}
