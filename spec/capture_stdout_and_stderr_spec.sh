
Describe 'capture_stdout_and_stderr.sh'
  Include bin/capture_stdout_and_stderr.sh
  It 'outputs hello'
    When call capture_stdout_and_stderr
    The stdout should include "hello"
    The stdout should include "capture_stdout_and_stderr"
    The stdout should include "0.1.0"
    The status should equal 0
  End
End
