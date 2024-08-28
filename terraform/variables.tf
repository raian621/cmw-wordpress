variable "AVAILABILITY_ZONES" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1d"
  ]
}

variable "PREFERRED_AZ" {
  type = string
  default = "us-east-1a"
}
