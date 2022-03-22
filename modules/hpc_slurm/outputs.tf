/**
 * Copyright 2022 Google LLC
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

output "hpc_controller_ssh_command" {
  value = "gcloud compute ssh ${google_compute_instance.slurm_controller.name} --zone ${google_compute_instance.slurm_controller.zone} --project ${local.project.project_id}"
}

output "hpc_login_ssh_command" {
  value = "gcloud compute ssh ${google_compute_instance.login_node.name} --zone ${google_compute_instance.login_node.zone} --project ${local.project.project_id}"
}

output "network_id" {
  value = local.network.id
}

output "network_selflink" {
  value = local.network.self_link
}

output "project_id" {
  value = local.project.project_id
}

output "random_id" {
  value = local.random_id
}

output "subnet_selflink" {
  value = local.subnet.self_link
}