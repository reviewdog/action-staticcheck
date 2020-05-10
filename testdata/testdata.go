package testdata

import (
	"errors"
	"regexp"
)

const (
	First  byte = 1
	Second      = 2
)

func unused() {
	regexp.Compile(".+")

	if errors.New("abc") == errors.New("abc") {
		// test SA4000
	}
}
