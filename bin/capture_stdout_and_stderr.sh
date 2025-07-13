#!/usr/bin/env bash

capture_stdout_and_stderr()
{
  echo "hello_text_from_stdout"
  echo >&2 "error_text_from_stderr"
}

capture_stdout_and_stderr_help()
{
  echo "capture_stdout_and_stderr"
  echo "Version 0.2.0"
  echo "For usage information call: capture_stdout_and_stderr_help_usage"
}

capture_stdout_and_stderr_help_usage()
{
  echo "capture_stdout_and_stderr"
  echo "Usage:"
  echo
  echo "capture_stdout_and_stderr TODO"
}
