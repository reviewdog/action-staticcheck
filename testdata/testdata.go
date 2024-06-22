package testdata

import (
	"errors"
	"fmt"
	"regexp"
)

const (
	First  byte = 1
	Second      = 2
)

func unused() {
	regexp.Compile(".+")

	nonNilVar := []int{}

	if errors.New("abcd") == errors.New("abcd") {
		// Test SA4000
	}

	regexp.Compile(".\\")

	s := []string{}
	if s != nil { // test
		for _, x := range s {
			fmt.Println(x)
		}
	}

	if nonNilVar != nil {
		fmt.Println(nonNilVar)
	}
}
