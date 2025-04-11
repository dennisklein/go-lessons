# SPDX-FileCopyrightText: 2025 GSI Helmholtzzentrum für Schwerionenforschung GmbH <https://www.gsi.de/en/>
#
# SPDX-License-Identifier: LGPL-3.0-only

variable "OUTDIR" {
  default = "_out/"
}

variable "OUTPUT" {
  default = "type=local,dest=${OUTDIR}"
}

group "default" {
  targets = ["build", "record"]
}

target "build" {
  target = "buildresult"
  output = [OUTPUT]
}

target "record" {
  target = "recordresult"
  name   = "record-${item.cast}"
  matrix = {
    item = [
      { cast = "cli", rows = 3, cols = 30 }
    ]
  }
  args   = { CAST = item.cast, ROWS = item.rows, COLS = item.cols }
  output = [OUTPUT]
}
