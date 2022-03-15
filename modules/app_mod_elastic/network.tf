/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "elastic_search_network" {
  source = "../../helpers/tf_modules/net-vpc"

  project_id  = module.project.project_id
  name        = var.network_name
  vpc_create  = var.create_network
  description = "VPC network created via Terraform as part of RAD Lab."

  subnets = [{
    name          = var.subnet_name
    ip_cidr_range = var.network_cidr_block
    region        = var.region
    secondary_ip_range = {
      "${var.pod_ip_range_name}"     = var.pod_cidr_block
      "${var.service_ip_range_name}" = var.service_cidr_block
    }
  }]
}

// External access
resource "google_compute_router" "router" {
  count = var.enable_internet_egress_traffic ? 1 : 0

  project = module.project.project_id
  name    = "es-access-router"
  network = module.elastic_search_network.name
  region  = var.region

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  count                              = var.enable_internet_egress_traffic ? 1 : 0
  project                            = module.project.project_id
  name                               = "es-proxy-ext-access-nat"
  router                             = google_compute_router.router[0].name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

}

resource "google_compute_route" "external_access" {
  count            = var.enable_internet_egress_traffic ? 1 : 0
  project          = module.project.project_id
  dest_range       = "0.0.0.0/0"
  name             = "proxy-external-access"
  network          = module.elastic_search_network.name
  next_hop_gateway = "default-internet-gateway"
}

