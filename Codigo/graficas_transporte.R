# Ejecuta con Rscript graficas_transporte.R o con Source en RStudio.
# Las tres imágenes se guardan en figuras/ dentro del directorio de trabajo.
# Solo utiliza funciones incluidas en R.

dir.create("figuras", showWarnings = FALSE)
azul <- "#245789"
naranja <- "#C45D32"

guardar_png <- function(archivo, dibujar) {
  png(file.path("figuras", archivo), width = 1800, height = 1080, res = 180)
  on.exit(dev.off())
  par(mar = c(5, 5, 4, 2) + 0.1)
  dibujar()
}

# Transporte en Cifras 2021, tabla 1.8. Valores en millones de COP.
apropiacion <- c(Carretera = 8527211, Ferrocarril = 210265)
guardar_png("figura-1-apropiacion-2021.png", function() {
  posiciones <- barplot(apropiacion / 1000, col = c(azul, naranja),
    border = NA, ylim = c(0, 10000),
    main = "Apropiación presupuestal por modo, 2021",
    ylab = "Miles de millones de COP corrientes")
  etiquetas <- formatC(apropiacion / 1000, format = "f", digits = 3,
    big.mark = ".", decimal.mark = ",")
  text(posiciones, apropiacion / 1000, labels = etiquetas, pos = 3)
})

# Transporte en Cifras 2021, tabla 1.8, según la revisión del informe.
# El resto agrupa todos los demás modos.
compromisos <- c(Carretera = 84.99, "Otros modos" = 100 - 84.99)
guardar_png("figura-2-compromisos-2021.png", function() {
  posiciones <- barplot(compromisos, col = c(azul, "grey65"),
    border = NA, ylim = c(0, 100),
    main = "Participación en los compromisos sectoriales, 2021",
    ylab = "Porcentaje del total")
  etiquetas <- paste0(formatC(compromisos, format = "f", digits = 2,
    decimal.mark = ","), " %")
  text(posiciones, compromisos, labels = etiquetas, pos = 3)
})

# Hoja Tabla limpia del Excel del proyecto. Serie provisional.
carga <- data.frame(
  anio = 2016:2024,
  carretera = c(103.81, 107.29, 112.44, 118.81, 108.72, 123.71, 135.63, 135.97, 145.05),
  ferrocarril = c(55.29, 50.43, 47.56, 50.36, 35.67, 31.86, 30.80, 31.13, 32.43)
)
guardar_png("figura-3-carga-2016-2024.png", function() {
  matplot(carga$anio, carga[c("carretera", "ferrocarril")],
    type = "o", lty = 1, lwd = 2, pch = c(16, 17),
    col = c(azul, naranja), xaxt = "n", ylim = c(0, 160),
    main = "Carga movilizada por carretera y ferrocarril, 2016–2024",
    xlab = "Año", ylab = "Millones de toneladas")
  axis(1, at = carga$anio)
  legend("topleft", legend = c("Carretera", "Ferrocarril"),
    col = c(azul, naranja), lty = 1, lwd = 2, pch = c(16, 17), bty = "n")
  mtext("Serie provisional del proyecto", side = 1, line = 3.5, cex = 0.8)
})
