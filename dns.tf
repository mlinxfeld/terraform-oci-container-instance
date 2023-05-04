resource "oci_dns_zone" "FoggyKitchenDNSZone" {
    count          = (var.enable_dns && var.enable_reserved_public_ip) ? 1 : 0 
    provider       = oci.homeregion
    compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
    name           = var.dns_domain
    zone_type      = "PRIMARY"
}

resource "oci_dns_rrset" "FoggyKitchenDNSPublicServerRecordA" {
    count           = (var.enable_dns && var.enable_reserved_public_ip) ? 1 : 0
    provider        = oci.homeregion
    domain          = var.dns_domain
    rtype           = "A"
    zone_name_or_id = oci_dns_zone.FoggyKitchenDNSZone[0].id
    compartment_id  = oci_identity_compartment.FoggyKitchenCompartment.id
    items {
        domain = var.dns_domain
        rdata =  oci_core_public_ip.FoggyKitchenContainerInstance_PublicReservedIP[0].ip_address    
        rtype = "A"
        ttl = var.dns_a_record_ttl
    }
}
