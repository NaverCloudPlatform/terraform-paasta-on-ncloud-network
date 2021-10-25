terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

provider "ncloud" {
  access_key = ""
  secret_key = ""
  // 수도권: KR, 남부권: KRS
  region = "KR"
  // NCLOUD_API_GW 환경 변수를 사용하는 경우 아래 설정을 제외해야함
  // https://github.com/NaverCloudPlatform/terraform-provider-ncloud/blob/master/ncloud/provider.go#L63-L72
  site        = "gov"
  support_vpc = true
}
