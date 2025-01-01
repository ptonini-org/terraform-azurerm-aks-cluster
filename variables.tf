variable "name" {
  type = string
}

variable "rg" {
  type = object({
    name     = string
    location = string
    id       = string
  })
}

variable "vnet_id" {
  default = null
}

variable "node_resource_group" {
  default = null
}

variable "kubernetes_version" {}

variable "automatic_channel_upgrade" {
  default  = "stable"
  nullable = false
}

variable "oidc_issuer_enabled" {
  default  = true
  nullable = false
}

variable "workload_identity_enabled" {
  default  = true
  nullable = false
}

variable "keda_enabled" {
  default  = false
  nullable = false
}

variable "service_principal" {
  type = object({
    client_id     = string
    client_secret = string
  })
  default = null
}

variable "identity" {
  type = object({
    type         = optional(string, "SystemAssigned")
    identity_ids = optional(set(string), [])
  })
  default = {}
}

variable "key_vault_secrets_provider" {
  type = object({
    secret_rotation_enabled  = optional(bool, true)
    secret_rotation_interval = optional(number)
  })
  default = {}
}

variable "network_profile" {
  type = object({
    network_plugin = optional(string, "kubenet")
    pod_cidr       = optional(string, "172.25.0.0/16")
    service_cidr   = optional(string, "172.20.0.0/16")
    dns_service_ip = optional(string, "172.20.0.10")
    outbound_type  = optional(string, "loadBalancer")
  })
  default = {}
}

variable "linux_profile" {
  type = object({
    admin_username = optional(string, "kube-admin")
    ssh_key_data   = string
  })
  default = null
}

variable "identities" {
  type = map(object({
    namespace = string
    role_assignments = optional(map(object({
      scope                = string
      role_definition_name = string
    })), {})
  }))
  default  = {}
  nullable = false
}

# Control plane api access ####################################################

variable "private_dns_zone_id" {
  default  = "None"
  nullable = false
}

variable "dns_prefix" {
  default = null
}

variable "private_cluster_enabled" {
  default  = true
  nullable = false
}

variable "private_cluster_public_fqdn_enabled" {
  default  = true
  nullable = false
}

# RBAC and authentication #####################################################

variable "role_based_access_control_enabled" {
  default  = true
  nullable = false
}

variable "local_account_disabled" {
  default  = true
  nullable = false
}

variable "aad_rbac" {
  type = object({
    azure_rbac_enabled     = optional(bool, true)
    admin_group_object_ids = optional(set(string))
  })
  default = {}
}

# Node pools ##################################################################

variable "default_node_pool_subnet_id" {}

variable "node_pools" {
  type = map(object({
    default                     = optional(bool)
    auto_scaling_enabled        = optional(bool, true)
    node_count                  = optional(number)
    min_count                   = optional(number, 1)
    max_count                   = optional(number)
    vm_size                     = optional(string)
    vnet_subnet_id              = optional(string)
    orchestrator_version        = optional(string)
    node_labels                 = optional(map(string))
    node_taints                 = optional(set(string))
    scale_down_mode             = optional(string, "Delete")
    os_disk_type                = optional(string, "Managed")
    type                        = optional(string, "VirtualMachineScaleSets")
    ultra_ssd_enabled           = optional(bool, false)
    temporary_name_for_rotation = optional(string, "temp")
    linux_os_config = optional(object({
      sysctl_config = optional(object({
        vm_max_map_count = optional(number)
      }))
    }))
  }))
  default  = {}
  nullable = false
}
