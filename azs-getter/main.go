package main

import (
	"context"
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	awscreds "github.com/aws/aws-sdk-go-v2/credentials"
	"gopkg.in/yaml.v3"

	"github.com/giantswarm/azs-getter/internal/awshelper"
)

type credentials struct {
	accessKeyId     string
	secretAccessKey string
	region          string
}

func main() {
	ctx := context.TODO()

	creds := []credentials{
		{
			// EUROPE
			accessKeyId:     os.Getenv("AWS_ACCESS_KEY_ID_EUROPE"),
			secretAccessKey: os.Getenv("AWS_SECRET_ACCESS_KEY_EUROPE"),
			region:          "eu-west-1",
		},
		{
			// CHINA
			accessKeyId:     os.Getenv("AWS_ACCESS_KEY_ID_CHINA"),
			secretAccessKey: os.Getenv("AWS_SECRET_ACCESS_KEY_CHINA"),
			region:          "cn-north-1",
		},
	}

	data := map[string][]string{}

	for _, c := range creds {
		sdkConfig, err := config.LoadDefaultConfig(ctx, config.WithCredentialsProvider(awscreds.NewStaticCredentialsProvider(c.accessKeyId, c.secretAccessKey, "")), config.WithRegion(c.region))
		if err != nil {
			fmt.Println("Couldn't load default configuration. Have you set up your AWS account?")
			fmt.Println(err)
			return
		}

		azsPerRegion, err := getAzsFromCredentials(ctx, sdkConfig)
		if err != nil {
			fmt.Println("Error getting azs")
			fmt.Println(err)
			return
		}

		for r, azs := range azsPerRegion {
			data[r] = azs
		}
	}

	b, err := yaml.Marshal(data)
	if err != nil {
		fmt.Println("error marshaling azs to yaml")
		fmt.Println(err)
		return
	}

	fmt.Print(string(b))
}

func getAzsFromCredentials(ctx context.Context, sdkConfig aws.Config) (map[string][]string, error) {
	helper, err := awshelper.New(sdkConfig)
	if err != nil {
		fmt.Println("Error initializing aws helper")
		return nil, err
	}

	regions, err := helper.ListRegions(ctx)
	if err != nil {
		fmt.Println("Error listing regions")
		return nil, err
	}

	ret := make(map[string][]string)

	for _, region := range regions {
		azs, err := helper.GetAzsForRegion(ctx, region)
		if err != nil {
			fmt.Printf("Couldn't get azs for region %s", region)
			return nil, err
		}

		ret[region] = azs
	}

	return ret, nil
}
