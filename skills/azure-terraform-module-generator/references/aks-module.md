# Azure AKS Module Reference

## Purpose

Use this reference when generating, reviewing, or extending reusable Azure Kubernetes Service modules.

The AKS module is a primitive resource module for the AKS cluster resource family. It should create the cluster and directly related AKS child or extension resources, while consuming infrastructure such as resource groups, subnets, identities, and monitoring destinations through explicit inputs.

## Module Type

This is a primitive resource module.

It may manage:

- `azurerm_kubernetes_cluster`
- optional additional `azurerm_kubernetes_cluster_node_pool` resources
- system-assigned or user-assigned cluster identity configuration
- AKS network profile and private cluster settings
- AKS add-ons such as Azure Policy, Key Vault Secrets Provider, workload identity, and OMS agent when explicitly configured
- optional cluster-scoped diagnostic settings
- optional role assignments directly needed by the cluster lifecycle

It should not manage:

- resource groups
- virtual networks or subnets
- Log Analytics workspaces
- private DNS zones unless explicitly supplied and attached
- application workloads, namespaces, Helm charts, or Kubernetes providers
- landing-zone policy and subscription governance

## Baseline Contract

The module should support:

- explicit cluster name through `name`
- computed cluster name through `context`
- required `resource_group_name`
- required `location`
- explicit `dns_prefix` or deterministic default from cluster name
- required default node pool configuration
- optional additional node pools as a map
- optional private cluster configuration
- optional Azure RBAC configuration
- optional diagnostic settings
- optional role assignments as a map
- optional `tags`

Current preferred naming shape:

```text
aks-<org>-<app>-<env>-<region>-<instance>
```

## Network Guidance

AKS should consume network dependencies explicitly:

- default node pool should accept `subnet_id`
- extra node pools should accept optional `subnet_id` and fall back to the default subnet when unset
- service CIDR, DNS service IP, pod CIDR, outbound type, and network policy should be explicit in `network_profile`
- the AKS module should not look up VNets or subnets by naming convention
- any role assignment for kubelet or cluster identity on a subnet should be opt-in and map-based

## Security Defaults

Recommended defaults:

- managed identity enabled by default
- local account disabled by default
- Azure RBAC enabled by default when Azure AD RBAC is configured
- public API server allowed only when caller leaves private cluster disabled
- no admin credentials, no public node IPs by default
- workload identity and OIDC issuer enabled by default for modern clusters
- Azure Policy enabled by default only if the platform standard requires it; otherwise keep it configurable

Do not create broad roles automatically. Accept principal IDs and role names or role definition IDs from callers when role assignments are required.

## Cost And Test Guidance

AKS is expensive and slow compared with primitive resources such as resource groups or VNets.

Testing should usually be plan-only unless the user explicitly approves apply testing.

Required examples:

- `basic`: one cluster using a subnet from the network module
- `complete`: private cluster settings, extra node pool, Azure RBAC, diagnostics input shape, and optional add-ons

Plan assertions should cover:

- cluster name and DNS prefix
- default node pool subnet ID
- optional extra node pool map resources
- private cluster flag behavior
- diagnostic setting creation only when configured

## Outputs

Output at least:

- cluster name and ID
- kubelet identity object or IDs needed for downstream RBAC
- cluster identity principal ID when available
- node resource group
- OIDC issuer URL
- private FQDN and public FQDN when available
- node pool IDs keyed by caller-defined keys

Avoid outputting kubeconfig by default. If a kubeconfig output is added later, mark it sensitive and document the security implications.
