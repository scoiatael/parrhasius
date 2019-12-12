package main

import "C"

import (
	"encoding/hex" // To transform the byte array to hex
	"flag"
	"fmt"
	"log"

	"github.com/devedge/imagehash"
)

var filename = flag.String("filename", "", "specify file to open")

func hash(filename string) (string, error) {
	src, err := imagehash.OpenImg(filename)
	if err != nil {
		return "", err
	}

	// The length of a downscaled side. It must be > 8, and
	// (hashLen * hashLen) must be a multiple of 8
	hashLen := 8
	// A value of 8 will return 64 bits, or 8 bytes / 16 hex characters
	// (64 bits = 8 bits length * 8 bits width)

	hash, err := imagehash.Dhash(src, hashLen)
	if err != nil {
		return "", err
	}
	return hex.EncodeToString(hash), nil
}

type cstring *C.char

//export ExtHash
func ExtHash(filename cstring) (cstring, cstring) {
	h, err := hash(C.GoString(filename))
	if err != nil {
		return nil, C.CString(fmt.Sprintf("%+v", err))
	}
	return C.CString(h), nil
}

func main() {
	flag.Parse()
	if len(*filename) <= 0 {
		log.Fatal("Expected -filename arg")
	}
	h, err := hash(*filename)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(h)
}
