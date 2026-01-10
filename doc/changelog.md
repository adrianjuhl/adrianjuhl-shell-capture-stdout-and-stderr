
# Changelog

## Versions

### 0.1.0

Initial development version. Prints a string to stdout.

### 0.2.0

Adds output to stderr.

### 0.6.0

Implements all required functionality:
  - the standard output and standard error are captured to named variables
  - the return code of the capture function is the return code of the command
  - any nulls occuring in standard output or standard error are stipped out (standard capture_stdout_and_stderr function)
  - standard output and standard error are base64 encoded (maintaining their values including any contianed nulls) (alternate capture_stdout_and_stderr_base64 function)

### 0.7.0

Minor simplification to have capture_stdout_and_stderr not set or re-set any shell options when capture_stdout_and_stderr runs the given command.

For example, if the xtrace option is enabled when capture_stdout_and_stderr is called then trace output will be mixed in with the given command's captured stderr.

It is now the responsiblity of the caller to set shell options as appropriate prior to calling capture_stdout_and_stderr.

Previously, capture_stdout_and_stderr would unconditionally disable the xtrace option in its sub-shell where it would run the given command. This is one notable shell option that, if enabled in the script that calls capture_stdout_and_stderr, may be necessary to disable prior to the call to capture_stdout_and_stderr, in this case to prevent trace output being mixed in with the command's captured stderr.
