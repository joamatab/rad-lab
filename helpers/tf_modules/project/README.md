# Project

The purpose of this module is to create a GCP project.  

## Project Name & Project ID
The logic to set the project name and project ID works as follows:
* When the variable `project_name` is set, that name will be used for the project. If no name is set, the project ID will be used.
* When the variable `project_id` is set, it will be used.  If no value is set, the value for `project_name` will be used, appended with the `random_id`. 

### Existing projects
When users want to deploy in an existing project, make sure that the following variables are set:
* `create_project`: true
* `project_id`: ID of the project where the resources should be deployed.

## Examples

### Create the minimal setup

```hcl
module "project" {
  src = "./project"
  
  billing_account_id  = "xyz-xyz-xyz"
  parent              = "folders/123456789"
  project_services    = [
    "compute.googleapis.com",
    "storage.googleapis.com"
  ] 
}
```

### Use existing project
```hcl
module "project" {
  src = "./project"
  
  billing_account_id  = "xyz-xyz-xyz"
  parent              = "folders/123456789"
  project_id          = "existing-project-id"
}
``` 