package awshelper

import (
	"context"
	"fmt"
	"strings"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/ec2/types"
)

type AwsHelper struct {
	sdkConfig aws.Config
}

func New(awsConfig aws.Config) (*AwsHelper, error) {
	return &AwsHelper{
		sdkConfig: awsConfig,
	}, nil
}

func (a *AwsHelper) ListRegions(ctx context.Context) ([]string, error) {
	ec2Client := ec2.NewFromConfig(a.sdkConfig)
	regionsOutput, err := ec2Client.DescribeRegions(ctx, &ec2.DescribeRegionsInput{
		AllRegions: aws.Bool(false),
	})

	if err != nil {
		fmt.Println("Couldn't get regions")
		return nil, err
	}

	ret := make([]string, 0)
	for _, region := range regionsOutput.Regions {
		ret = append(ret, *region.RegionName)
	}

	return ret, nil
}

func (a *AwsHelper) GetAzsForRegion(ctx context.Context, region string) ([]string, error) {
	config := a.sdkConfig
	config.Region = region
	ec2Client := ec2.NewFromConfig(config)

	azsOutput, err := ec2Client.DescribeAvailabilityZones(ctx, &ec2.DescribeAvailabilityZonesInput{
		AllAvailabilityZones: aws.Bool(true),
		Filters:              []types.Filter{{Name: aws.String("zone-type"), Values: []string{"availability-zone"}}},
	})

	if err != nil {
		return nil, err
	}

	// We just want the zone letter (such as "a") rather than the full zone name (such as "us-west-2a")
	zoneNames := make([]string, 0)
	for _, az := range azsOutput.AvailabilityZones {
		clean, _ := strings.CutPrefix(*az.ZoneName, region)
		zoneNames = append(zoneNames, clean)
	}

	return zoneNames, nil
}
