
# Verify that:
#   - stdout is produced and contains hello_text_from_stdout
#   - stderr is produced and contains error_text_from_stderr
#   - exit status is 0
# TODO will eventually need to check that stdout and stderr is captured into variables and that each variable contains the expected value
Describe 'capture_stdout_and_stderr'
  Include bin/capture_stdout_and_stderr.sh
  It 'stdout contains hello_text_from_stdout'
    When call capture_stdout_and_stderr
    The stdout should include "hello_text_from_stdout"
    The stderr should include "error_text_from_stderr"
    The status should equal 0
  End
End

Describe 'capture_stdout_and_stderr_help'
  Include bin/capture_stdout_and_stderr.sh
  It 'outputs help info'
    When call capture_stdout_and_stderr_help
    The stdout should include "Version 0.2.0"
    The stdout should include "For usage information call: capture_stdout_and_stderr_help_usage"
    The status should equal 0
  End
End

Describe 'capture_stdout_and_stderr_help_usage'
  Include bin/capture_stdout_and_stderr.sh
  It 'outputs usage info'
    When call capture_stdout_and_stderr_help_usage
    The stdout should include "Usage"
    The status should equal 0
  End
End
