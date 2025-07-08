package apputils

import (
	"fmt"
	"image"
	_ "image/gif" // register GIF decoder
	"image/jpeg"
	_ "image/png" // register PNG decoder
	"mime/multipart"
	"os"
	"path/filepath"
	"strings"

	"github.com/google/uuid"
)

// CompressImage accepts a multipart file header, opens the file, decodes it as an image,
// and re-encodes it as a JPEG with a standard quality level to reduce file size.
// It saves the compressed image to a file in the "image" directory and returns the file path.
func CompressImage(fileHeader *multipart.FileHeader) (string, error) {
	// Open the file from the header
	file, err := fileHeader.Open()
	if err != nil {
		return "", fmt.Errorf("failed to open file from header: %w", err)
	}
	defer file.Close()

	// Decode the image. The blank import for image/png and image/gif allows image.Decode
	// to understand these formats.
	img, _, err := image.Decode(file)
	if err != nil {
		return "", fmt.Errorf("failed to decode image: %w", err)
	}

	// Define the output directory for compressed images
	const outputDir = "image"
	// Create the directory if it doesn't exist
	// if err := os.MkdirAll(outputDir, os.ModePerm); err != nil {
	// 	return "", fmt.Errorf("failed to create image directory: %w", err)
	// }

	// Generate a unique filename for the compressed image.
	filename := strings.Replace(uuid.New().String(), "-", "", -1) + ".jpeg"
	filePath := filepath.Join(outputDir, filename)

	// Create the output file.
	outFile, err := os.Create(filePath)
	if err != nil {
		return "", fmt.Errorf("failed to create output file: %w", err)
	}
	defer outFile.Close()

	// Encode the image as a JPEG with a quality of 75.
	// This is a good balance between quality and file size.
	options := &jpeg.Options{Quality: 75}
	if err := jpeg.Encode(outFile, img, options); err != nil {
		return "", fmt.Errorf("failed to encode image to jpeg: %w", err)
	}

	return filePath, nil
}
