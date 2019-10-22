package main

import (
	"github.com/labstack/echo"
	"log"
	"context"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	echolamda"github.com/awslabs/aws-lambda-go-api-proxy/echo"
)

//コールドスタートだと毎回mainだけ叩いてくれるわけではないらしく、grobalにechoLambdaを持つのがセオリーっぽい
var echoLambda *echolamda.EchoLambda

func init() {
	// stdout and stderr are sent to AWS CloudWatch Logs
	log.Printf("Echo cold start")
	e := echo.New()
	//ここでルーティング
	e.GET("/ping", func(c echo.Context) error{
		return c.NoContent(http.StatusNoContent)
	})
	echoLambda = echolamda.New(e)
}

func Handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	// If no name is provided in the HTTP request body, throw an error
	// 中でServeHTTPを叩いている
	return echoLambda.ProxyWithContext(ctx, req)
}

func main() {
	lambda.Start(Handler)
}