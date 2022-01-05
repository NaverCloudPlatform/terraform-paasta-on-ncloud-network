resource "ncloud_vpc" "vpc" {
  name            = "paasta-vpc"  // VPC 이름
  ipv4_cidr_block = "10.0.0.0/16" // VPC CIDR
}
resource "ncloud_network_acl" "nacl" {
  vpc_no = ncloud_vpc.vpc.id
}
resource "ncloud_access_control_group" "paasta_manager_acg" {
  name   = "paasta-manager-acg" // PaaS-TA Manager ACG 이름
  vpc_no = ncloud_vpc.vpc.id
}
resource "ncloud_access_control_group_rule" "acg-rule" {
  access_control_group_no = ncloud_access_control_group.paasta_manager_acg.id

  // PaaS-TA Manager ACG 규칙
  inbound {
    protocol   = "TCP"
    ip_block   = ncloud_vpc.vpc.ipv4_cidr_block
    port_range = "22"
  }

  inbound {
    protocol   = "TCP"
    ip_block   = ncloud_vpc.vpc.ipv4_cidr_block
    port_range = "6868"
  }

  inbound {
    protocol   = "TCP"
    ip_block   = ncloud_vpc.vpc.ipv4_cidr_block
    port_range = "25555"
  }

  outbound {
    protocol = "ICMP"
    ip_block = "0.0.0.0/0"
  }
  outbound {
    protocol   = "UDP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }
  outbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }
}
resource "ncloud_access_control_group" "paasta_core_acg" {
  name   = "paasta-core-acg" // PaaS-TA Core ACG 이름
  vpc_no = ncloud_vpc.vpc.id
}

resource "ncloud_access_control_group_rule" "paasta_core_acg_rule" {
  access_control_group_no = ncloud_access_control_group.paasta_core_acg.id

  // PaaS-TA Core ACG 규칙
  inbound {
    protocol   = "TCP"
    ip_block   = ncloud_vpc.vpc.ipv4_cidr_block
    port_range = "1-65535"
  }
  inbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = "80"
  }
  inbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = "443"
  }
  inbound {
    protocol   = "UDP"
    ip_block   = ncloud_vpc.vpc.ipv4_cidr_block
    port_range = "1-65535"
  }
  outbound {
    protocol = "ICMP"
    ip_block = "0.0.0.0/0"
  }
  outbound {
    protocol   = "UDP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }
  outbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }
}
resource "ncloud_access_control_group" "paasta_svc_acg" {
  name   = "paasta-svc-acg" // PaaS-TA Service ACG 이름
  vpc_no = ncloud_vpc.vpc.id
}
resource "ncloud_access_control_group_rule" "paasta_svc_acg_rule" {
  access_control_group_no = ncloud_access_control_group.paasta_svc_acg.id

  // PaaS-TA Service ACG 규칙
  inbound {
    protocol   = "TCP"
    ip_block   = ncloud_vpc.vpc.ipv4_cidr_block
    port_range = "1-65535"
  }
  inbound {
    protocol   = "UDP"
    ip_block   = ncloud_vpc.vpc.ipv4_cidr_block
    port_range = "1-65535"
  }
  outbound {
    protocol = "ICMP"
    ip_block = "0.0.0.0/0"
  }
  outbound {
    protocol   = "UDP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }
  outbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }
}
resource "ncloud_access_control_group" "paasta_svc_db_acg" {
  name   = "paasta-svc-db-acg" // PaaS-TA DB Service ACG 이름
  vpc_no = ncloud_vpc.vpc.id
}
resource "ncloud_access_control_group_rule" "paasta_svc_db_acg_rule" {
  access_control_group_no = ncloud_access_control_group.paasta_svc_db_acg.id

  // PaaS-TA DB Service ACG 규칙
  inbound {
    protocol   = "TCP"
    ip_block   = ncloud_vpc.vpc.ipv4_cidr_block
    port_range = "3306"
  }

  outbound {
    protocol = "ICMP"
    ip_block = "0.0.0.0/0"
  }
  outbound {
    protocol   = "UDP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }
  outbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }
}

resource "ncloud_subnet" "paasta_lb_subnet" {
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = "10.0.100.0/24" // LB Subnet CIDR
  zone           = "KR-1"          // 수도권: KR-1, 남부권 KRS-1
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PRIVATE"          // PUBLIC(Public) | PRIVATE(Private)
  name           = "paasta-lb-subnet" // LB Subnet 이름
  usage_type     = "LOADB"            // GEN(General) | LOADB(For load balancer)
}

resource "ncloud_subnet" "paasta_manager_subnet" {
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = "10.0.1.0/24" // PaaS-TA Manager Subnet CIDR
  zone           = "KR-1"        // 수도권: KR-1, 남부권 KRS-1
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PRIVATE"               // PUBLIC(Public) | PRIVATE(Private)
  name           = "paasta-manager-subnet" // PaaS-TA Manager Subnet 이름 
  usage_type     = "GEN"                   // GEN(General) | LOADB(For load balancer)
}

resource "ncloud_subnet" "paasta_core_subnet" {
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = "10.0.2.0/24" // PaaS-TA Core Subnet CIDR
  zone           = "KR-1"        // 수도권: KR-1, 남부권 KRS-1
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PRIVATE"            // PUBLIC(Public) | PRIVATE(Private)
  name           = "paasta-core-subnet" // PaaS-TA Core Subnet 이름 
  usage_type     = "GEN"                // GEN(General) | LOADB(For load balancer)
}
resource "ncloud_subnet" "paasta_svc_db_subnet" {
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = "10.0.3.0/24" // PaaS-TA DB Service Subnet CIDR
  zone           = "KR-1"        // 수도권: KR-1, 남부권 KRS-1
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PRIVATE"              // PUBLIC(Public) | PRIVATE(Private)
  name           = "paasta-svc-db-subnet" // PaaS-TA DB Service Subnet 이름 
  usage_type     = "GEN"                  // GEN(General) | LOADB(For load balancer)
}
resource "ncloud_subnet" "paasta_svc_subnet" {
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = "10.0.4.0/24" // PaaS-TA Service Subnet CIDR
  zone           = "KR-1"        // 수도권: KR-1, 남부권 KRS-1
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PRIVATE"           // PUBLIC(Public) | PRIVATE(Private)
  name           = "paasta-svc-subnet" // PaaS-TA Service Subnet 이름 
  usage_type     = "GEN"               // GEN(General) | LOADB(For load balancer)
}

resource "ncloud_nat_gateway" "nat_gateway" {
  vpc_no = ncloud_vpc.vpc.id
  zone   = "KR-1"          // 수도권: KR-1, 남부권 KRS-1
  name   = "paasta-nat-gw" // NAT Gateway 이름 
}

data "ncloud_route_table" "reoute_table" {
  vpc_no                = ncloud_vpc.vpc.id
  supported_subnet_type = "PRIVATE"
  filter {
    name = "is_default"
    values = ["true"]
  }
}

resource "ncloud_route" "route" {
  route_table_no         = data.ncloud_route_table.reoute_table.id
  destination_cidr_block = "0.0.0.0/0"
  target_type            = "NATGW"  // NATGW (NAT Gateway) | VPCPEERING (VPC Peering) | VGW (Virtual Private Gateway).
  target_name            = ncloud_nat_gateway.nat_gateway.name
  target_no              = ncloud_nat_gateway.nat_gateway.id
}

resource "ncloud_lb" "lb" {
  name = "paasta-lb"
  network_type = "PUBLIC"
  type = "NETWORK"
  subnet_no_list = [ ncloud_subnet.paasta_lb_subnet.subnet_no ]
}