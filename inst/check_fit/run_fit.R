library(LAMRSAControl)
data("fit")
fit <- lapply(1:1000, function(x) {
    cat(x, "\n")
    MRSA_distance(run(fit), MRSA_expected(), simplify = FALSE)
})
save(fit, file = "runfit.Rda")
