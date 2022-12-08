# Configure the GitLab Provider
terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "3.18.0"
    }
  }
}

provider "gitlab" {
  token    = var.gitlab_token
  base_url = var.gitlab_url
  #insecure = true
}

# Add a group
resource "gitlab_group" "demo_group" {
  name             = "Demo Content"
  path             = "demo-content"
  description      = "A group for demo content"
  visibility_level = "public"
}

# Add a project
resource "gitlab_project" "java_hello" {
  name                       = "java-hello"
  namespace_id               = gitlab_group.demo_group.id
  description                = "Java Hello World App"
  visibility_level           = "public"
  default_branch             = "main"
  initialize_with_readme     = false

  container_registry_enabled = true
  issues_enabled             = true
  merge_requests_enabled     = true
  packages_enabled           = true
  pipelines_enabled          = true
  wiki_enabled               = true
  wiki_access_level          = "enabled"

}

# Add branch protection to the project
resource "gitlab_branch_protection" "java_hello_branch_protection" {
  project = gitlab_project.java_hello.id
  branch  = "main"
  push_access_level = "maintainer"
  merge_access_level = "maintainer"
  unprotect_access_level = "maintainer"
}

# Add a milestone to the project
resource "gitlab_project_milestone" "java_hello_mvp_milestone" {
  project     = gitlab_project.java_hello.id
  title       = "Java Hello World MVP milestone"
  description = "This is a milestone for MVP of Java Hello World App"
}

# Add a few issues to the project 
resource "gitlab_project_issue" "java_hello_design_issue" {
  project      = gitlab_project.java_hello.id
  title        = "Hello World Design"
  description  = "Write the design details for a super amazing hello world app"
  milestone_id = gitlab_project_milestone.java_hello_mvp_milestone.milestone_id
  state        = "closed"
}

resource "gitlab_project_issue" "java_hello_mvp_issue" {
  depends_on = [
    gitlab_project_issue.java_hello_design_issue
  ]
  project      = gitlab_project.java_hello.id
  title        = "Hello World MVP"
  description  = "Build a Java Hello World App"
  milestone_id = gitlab_project_milestone.java_hello_mvp_milestone.milestone_id
  state        = "opened"
}

# Add a branch 
resource "gitlab_branch" "java_hello_branch" {
  project = gitlab_project.java_hello.id
  name    = "java-hello-mvp"
  ref     = "main"
}

# Add repository files in for_each loop
resource "gitlab_repository_file" "java_hello_files" {
  for_each = fileset(path.module, "files/**")
 
  project        = gitlab_project.java_hello.id
  branch         = gitlab_branch.java_hello_branch.name
  file_path      = trimprefix(each.key, "files/")
  content        = each.value

  author_email   = "gitlab@example.com"
  author_name    = "Gitlab"
  commit_message = "feature: java hello world mvp"
}

# Add a project 
resource "gitlab_project" "python_hello" {
  name                       = "python-hello"
  namespace_id               = gitlab_group.demo_group.id
  description                = "Python Hello World App"
  visibility_level           = "public"
  default_branch             = "main"

  container_registry_enabled = true
  issues_enabled             = true
  merge_requests_enabled     = true
  packages_enabled           = true
  pipelines_enabled          = true
  wiki_enabled               = true
  wiki_access_level          = "enabled"

}
