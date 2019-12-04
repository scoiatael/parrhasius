package main

import (
	"fmt"
	"log"
	"flag"
	"encoding/hex"  // To transform the byte array to hex

	"github.com/devedge/imagehash"
)
var filename = flag.String("filename", "", "specify file to open; will read STDIN otherwise")

func main() {
	flag.Parse()
	if len(*filename) <= 0 {
		log.Fatal("Expected -filename arg")
	}
	src, err := imagehash.OpenImg(*filename)
	if err != nil {
		log.Fatal(err)
	}

	// The length of a downscaled side. It must be > 8, and
	// (hashLen * hashLen) must be a multiple of 8
	hashLen := 8
	// A value of 8 will return 64 bits, or 8 bytes / 16 hex characters
	// (64 bits = 8 bits length * 8 bits width)

	hash, err := imagehash.Dhash(src, hashLen)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(hex.EncodeToString(hash))
}
