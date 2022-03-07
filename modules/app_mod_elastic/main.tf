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

module "project" {
  source = "../../helpers/tf_modules/project"

  billing_account_id = var.billing_account_id
  create_project     = var.create_project
  parent             = length(var.folder_id) != 0 ? "folders/${var.folder_id}" : "organizations/${var.organization_id}"
  labels             = var.labels
  random_id          = var.random_id
  project_id         = var.project_name
  project_name       = var.project_name

  project_services = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com"
  ]
}

resource "google_service_account" "elastic_search_gcp_identity" {
  project      = module.project.project_id
  account_id   = "elastic-search-id"
  description  = "Elastic Search pod identity."
  display_name = "Elastic Search Identity"
}

resource "google_service_account_iam_member" "elastic_search_k8s_identity" {
  member             = "serviceAccount:${module.project.project_id}.svc.id.goog[${local.k8s_namespace}/${local.elastic_search_identity_name}]"
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.elastic_search_gcp_identity.id

  depends_on = [
    module.gke_cluster
  ]
}
