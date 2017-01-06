lintr::lint_package(
  linters = lintr::with_defaults(
    trailing_whitespace_linter = NULL,
    camel_case_linter = NULL,
    commented_code_linter = NULL,
    line_length_linter = NULL
    )
)
