data "external" "download_defender_layer" {
  program = ["bash", "${path.module}/download-layer.sh"]

  query = {
    # arbitrary map from strings to strings, passed to the external program as the data query.
    pcc_url  = var.console_url
    pcc_user = var.prisma_username
    pcc_pass = var.prisma_password
    pcc_san  = var.console_san
    filename = var.layer_filename
    runtime  = var.runtime
  }
}

resource "aws_lambda_layer_version" "prismacloud_layer" {
  filename            = data.external.download_defender_layer.result.filename
  layer_name          = var.layer_name
  compatible_runtimes = var.compatible_runtimes
  source_code_hash    = filesha256(data.external.download_defender_layer.result.filename)
}


