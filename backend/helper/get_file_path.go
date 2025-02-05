package helper

import "strings"

func GetFilePath(fileURL string) string {
	index := strings.Index(fileURL, "/")
	if index == -1 {
		return ""
	}

	return fileURL[index+1:]
}
