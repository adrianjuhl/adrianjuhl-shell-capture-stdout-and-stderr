
script_under_test="bin/capture_stdout_and_stderr.sh"

support_function_hello_goodbye_7()
  # outputs "hello" to stdout, "goodbye" to stderr, and sets exit status to 7
{
  printf "hello"
  printf "goodbye" >&2
  return 7
}

support_function_purple_orange_23()
  # outputs "purple" to stdout, "orange" to stderr, and returns 23
{
  printf "purple"
  printf "orange" >&2
  return 23
}

support_function_rednullred_bluenullblue_24()
  # outputs "red\0red" to stdout, "blue\0blue" to stderr, and returns 24
{
  printf "red\0red"
  printf "blue\0blue" >&2
  return 24
}

support_function_firstinput1_secondinput2_25()
  # outputs "first<param1>" to stdout, "second<param2>" to stderr, and returns 25
{
  printf "first%s" "${1}"
  printf "second%s" "${2}" >&2
  return 25
}

support_function_to_help_verify_count_of_command_calls()
  # outputs "hello" to stdout, "goodbye" to stderr
  # and writes a line to /tmp/function_call_counter
{
  echo "called" >> /tmp/function_call_counter
  printf "hello"
  printf "goodbye" >&2
}

Describe "capture_stdout_and_stderr"
  Include "${script_under_test}"
  It "should exit with non-zero status when called with zero parameters"
    When call capture_stdout_and_stderr
    The status should equal 1
    The stderr should be present
    The stderr should include "Error"
  End
  It "should exit with non-zero status if called with only one parameter"
    When call capture_stdout_and_stderr parameter_one
    The status should equal 1
    The stderr should be present
    The stderr should include "Error"
  End
  It "should exit with non-zero status if called with only two parameters"
    When call capture_stdout_and_stderr parameter_one parameter_two
    The status should equal 1
    The stderr should be present
    The stderr should include "Error"
  End
  It "should populate the named capture variables with the expected values"
    When call capture_stdout_and_stderr stdout_capture stderr_capture support_function_hello_goodbye_7
    The variable stdout_capture should equal "hello"
    The variable stderr_capture should equal "goodbye"
    The status should equal 7
  End
  Describe "should call the named command/function only once"
    setup() {
      # Initialize the function_call_counter file which is used to verify that the command that
      # capture_stdout_and_stderr is to call is called only once.
      echo -n "" > /tmp/function_call_counter;
    }
    Before "setup"
    It "should call the named command/function only once"
      When call capture_stdout_and_stderr stdout_capture stderr_capture support_function_to_help_verify_count_of_command_calls
      The variable stdout_capture should equal "hello"
      The variable stderr_capture should equal "goodbye"
      # Ensure that the named function is called only once.
      The lines of contents of file /tmp/function_call_counter should equal 1
      The contents of file /tmp/function_call_counter should equal "called"
    End
  End
  It "should populate the named capture variables with the expected values"
    When call capture_stdout_and_stderr foovar barvar support_function_hello_goodbye_7
    The variable foovar should equal "hello"
    The variable barvar should equal "goodbye"
    The status should equal 7
  End
  It "should populate the named capture variables with the expected values"
    When call capture_stdout_and_stderr stdout_capture stderr_capture support_function_purple_orange_23
    The variable stdout_capture should equal "purple"
    The variable stderr_capture should equal "orange"
    The status should equal 23
  End
  It "captures stdout that has been sanitized by stripping out NUL characters"
    When call capture_stdout_and_stderr stdout_capture stderr_capture support_function_rednullred_bluenullblue_24
    The variable stdout_capture should equal "redred"
    The variable stderr_capture should equal "blueblue"
    The status should equal 24
  End
  It "captures stdout of firsthello"
    When call capture_stdout_and_stderr stdout_capture stderr_capture support_function_firstinput1_secondinput2_25 hello world
    The variable stdout_capture should equal "firsthello"
    The variable stderr_capture should equal "secondworld"
    The status should equal 25
  End
  It "captures stderr"
    When call capture_stdout_and_stderr stdout_capture stderr_capture support_function_firstinput1_secondinput2_25 "hello world" "foo bar"
    The variable stdout_capture should equal "firsthello world"
    The variable stderr_capture should equal "secondfoo bar"
    The status should equal 25
  End
  It 'captures stdout that has been sanitized by base64 encoding'
    When call capture_stdout_and_stderr_base64 stdout_capture stderr_capture support_function_hello_goodbye_7
    The variable stdout_capture should equal "aGVsbG8="      # the base64 encoded value of "hello"
    The variable stderr_capture should equal "Z29vZGJ5ZQ=="  # the base64 encoded value of "goodbye"
    The status should equal 7
  End
  It 'captures stdout that has been sanitized by base64 encoding'
    When call capture_stdout_and_stderr_base64 stdout_capture stderr_capture support_function_rednullred_bluenullblue_24
    The variable stdout_capture should equal "cmVkAHJlZA=="  # the base64 encoded value of "red\0red" (red<null>red)
    The variable stderr_capture should equal "Ymx1ZQBibHVl"  # the base64 encoded value of "blue\0blue" (blue<null>blue)
    The status should equal 24
  End
End

Describe "capture_stdout_and_stderr_help"
  Include "${script_under_test}"
  It "should output help information"
    When call capture_stdout_and_stderr_help
    The stdout should include "capture_stdout_and_stderr"
    The stdout should include "Version 0.7.0"
    The stdout should include "For usage information call: capture_stdout_and_stderr_help_usage"
    The status should equal 0
  End
End

Describe "capture_stdout_and_stderr_help_usage"
  Include "${script_under_test}"
  It "should output usage information"
    When call capture_stdout_and_stderr_help_usage
    The stdout should include "capture_stdout_and_stderr"
    The stdout should include "Usage"
    The status should equal 0
  End
End
