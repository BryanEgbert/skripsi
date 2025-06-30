release:
	flutter build apk --split-per-abi --build-number 9 --build-name=1.0.0+9

build-analyze-size:
	flutter build apk --build-number 9 --build-name=1.0.0+9 --analyze-size --target-platform=android-arm64 

l10n:
	flutter gen-l10n

install:
	flutter install --use-application-binary=build/app/outputs/flutter-apk/app-arm64-v8a-release.apk