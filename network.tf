resource "oci_core_virtual_network" "FoggyKitchenVCN" {
  provider       = oci.targetregion
  cidr_block     = lookup(var.network_cidrs, "VCN-CIDR")
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name   = "FoggyKitchenVCN"
  dns_label      = "fkvcn"
}

resource "oci_core_internet_gateway" "FoggyKitchenInternetGateway" {
  provider       = oci.targetregion
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name   = "FoggyKitchenInternetGateway"
  enabled        = true
  vcn_id         = oci_core_virtual_network.FoggyKitchenVCN.id
}

resource "oci_core_route_table" "FoggyKitchenVCNPublicRouteTable" {
  provider       = oci.targetregion
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  vcn_id         = oci_core_virtual_network.FoggyKitchenVCN.id
  display_name   = "FoggyKitchenVCNPublicRouteTable"

  route_rules {
    description       = "Traffic to/from internet"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.FoggyKitchenInternetGateway.id
  }
}

resource "oci_core_security_list" "FoggyKitchenContainerInstanceSubnetSecurityList" {
  provider       = oci.targetregion
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name   = "FoggyKitchenContainerInstanceSubnetSecurityList"
  vcn_id         = oci_core_virtual_network.FoggyKitchenVCN.id

  # Ingress

  ingress_security_rules {
    source      = lookup(var.network_cidrs, "ALL-CIDR")
    source_type = "CIDR_BLOCK"
    protocol    = local.tcp_protocol_number
    stateless   = false

    tcp_options {
      max = local.ssh_port_number
      min = local.ssh_port_number
    }
  }

  ingress_security_rules {
    source      = lookup(var.network_cidrs, "ALL-CIDR")
    source_type = "CIDR_BLOCK"
    protocol    = local.tcp_protocol_number
    stateless   = false

    tcp_options {
      max = local.http_port_number
      min = local.http_port_number
    }
  }

  ingress_security_rules {
    source      = lookup(var.network_cidrs, "ALL-CIDR")
    source_type = "CIDR_BLOCK"
    protocol    = local.tcp_protocol_number
    stateless   = false

    tcp_options {
      max = local.https_port_number
      min = local.https_port_number
    }
  }


  ingress_security_rules {
    source      = lookup(var.network_cidrs, "ALL-CIDR")
    source_type = "CIDR_BLOCK"
    protocol    = local.icmp_protocol_number
    stateless   = false

    icmp_options {
      code = "4"
      type = "3"
    }
  }

  # Egress

  egress_security_rules {
    destination  = lookup(var.network_cidrs, "ALL-CIDR")
    protocol     = "all"
    stateless    = "false"
  }

}

resource "oci_core_subnet" "FoggyKitchenContainerInstanceSubnet" {
  provider                   = oci.targetregion
  cidr_block                 = lookup(var.network_cidrs, "CONTAINER-SUBNET-CIDR")
  compartment_id             = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name               = "FoggyKitchenContainerInstanceSubnet"
  dns_label                  = "consub"
  vcn_id                     = oci_core_virtual_network.FoggyKitchenVCN.id
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.FoggyKitchenVCNPublicRouteTable.id
  dhcp_options_id            = oci_core_virtual_network.FoggyKitchenVCN.default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.FoggyKitchenContainerInstanceSubnetSecurityList.id]
}


