package com.fitmgr.resourcecenter.service.network.firewall;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

@Data
public class FirewallRuleServiceVerifyBody {

    @JsonProperty("source_ip_addresses")
    private List<String> sourceIpAddresses;

    @JsonProperty("dest_ip_addresses")
    private List<String> destIpAddresses;
}
