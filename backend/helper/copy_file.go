package helper

import (
	"fmt"
	"io"
	"os"
)

func CopyFileIfNotExists(src, dest string) error {
	// Check if the destination file already exists
	if _, err := os.Stat(dest); err == nil {
		return nil
	} else if !os.IsNotExist(err) {
		// Return an error if there's an issue checking the file
		return fmt.Errorf("error checking destination file: %v", err)
	}

	// Open the source file
	srcFile, err := os.Open(src)
	if err != nil {
		return fmt.Errorf("error opening source file: %v", err)
	}
	defer srcFile.Close()

	// Create the destination file
	destFile, err := os.Create(dest)
	if err != nil {
		return fmt.Errorf("error creating destination file: %v", err)
	}
	defer destFile.Close()

	// Copy contents from source to destination
	_, err = io.Copy(destFile, srcFile)
	if err != nil {
		return fmt.Errorf("error copying file: %v", err)
	}

	return nil
}
