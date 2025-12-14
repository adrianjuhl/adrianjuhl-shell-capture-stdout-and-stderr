
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
