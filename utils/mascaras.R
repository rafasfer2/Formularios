# utils/mascaras.R

aplicarMascaras <- function(session) {
  observe({
    session$sendCustomMessage("applyMasks", list())
  })
}