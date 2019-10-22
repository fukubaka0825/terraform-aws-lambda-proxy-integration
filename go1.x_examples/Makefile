LAMDA_SOURRE_REPO=serverless-app
LAMDA_SOURRE_KEY=lambda/sample.zip
LAMDA_SOURCE_PATH=s3://${LAMDA_SOURRE_REPO}/${LAMDA_SOURRE_KEY}
deploy_dummy_code:
	aws s3 cp .build/dummy.zip ${LAMDA_SOURCE_PATH}
build_update:
	GOOS=linux GOARCH=amd64 go build -o .build/main source/main.go
	cd .build && zip -r sample.zip ./
	aws s3 cp .build/sample.zip ${LAMDA_SOURCE_PATH}
	aws lambda update-function-code --function-name sample-search-api --s3-bucket ${LAMDA_SOURRE_REPO} --s3-key ${LAMDA_SOURRE_KEY}
	echo 'Success to lambda update!'