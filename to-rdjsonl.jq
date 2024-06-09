{
  source: {
    name: "staticcheck",
    url: "https://staticcheck.io"
  },
  message: .message,
  code: {value: .code, url: "https://staticcheck.io/docs/checks#\(.code)"},
  location: {
    path: .location.file,
    range: {
      start: {
        line: .location.line,
        column: .location.column
      },
      end: {
        line: .end.line,
        column: .end.column
      }
    }
  },
  related_locations: (.related // {}) | map({
    message: .message,
    location: {
      path: .location.file,
      range: {
        start: {
          line: .location.line,
          column: .location.column
        },
        end: {
          line: .end.line,
          column: .end.column
        }
      }
    }
  }),
  severity: ((.severity|ascii_upcase|select(match("ERROR|WARNING|INFO")))//null)
}
