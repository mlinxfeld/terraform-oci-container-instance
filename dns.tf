resource "oci_dns_zone" "FoggyKitchenDNSZone" {
    count          = (var.enable_dns && var.enable_reserved_public_ip) ? 1 : 0 
    provider       = oci.homeregion
    compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
    name           = var.dns_domain
    zone_type      = "PRIMARY"
}

resource "oci_dns_record" "FoggyKitchenDNSPublicServerRecordA" {
    count           = (var.enable_dns && var.enable_reserved_public_ip) ? 1 : 0 
    provider        = oci.homeregion
    zone_name_or_id = oci_dns_zone.FoggyKitchenDNSZone[0].id
    domain          = var.dns_domain
    rtype           = "A"
    compartment_id  = oci_identity_compartment.FoggyKitchenCompartment.id
    rdata           = oci_core_public_ip.FoggyKitchenContainerInstance_PublicReservedIP[0].ip_address
    ttl             = var.dns_a_record_ttl
}
