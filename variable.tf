variable  "aws_access_key" {}
variable  "aws_secret_key" {}

variable "aws_region" {
    description = "Region for the VPC"
 }

#variable "inari-infra-staging-lb-ssl-certificate" {
#     description = "SSL Certificate to create secure load balancer listener"
#}

variable "root_domain_name" {
  description = "variable for root name (also known as zone apex or naked domain)"
}

#variable "faro-help-infra-staging-lb-ssl-certificate" {
#description = "load balancer certificate"
#}

variable "acm_certificate_arn" {}

variable "tag_name" {
    description = "give the tag name"
 }

variable "tag_Project" {
    description = "give the tag  Project"
 }

variable "tag_Environment" {
    description = "give the tag Environment"
 }


 #variable "office_ip"{
 #}