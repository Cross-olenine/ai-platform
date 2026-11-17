variable "catalog_path" {
  description = "Chemin du dossier catalog/ (relatif à ce module)."
  type        = string
  default     = "../../catalog"
}

variable "github_branches_pushed" {
  description = "Passer à true une fois les branches develop, test, preprod et main poussées : active branche par défaut et règles de protection."
  type        = bool
  default     = false
}
