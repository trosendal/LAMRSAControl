library(LAMRSAControl)
load("runfit.Rda")


## the order of the values in the MRSA_distance results are as
## follows. I will reorder to expect vector to be the same:
index <- c("q_m1s", "q_m2s", "q_m3s", "q_m2p", "q_m3p", "q_m4p", "q_m5p", "q_m6p")
ex <- MRSA_expected()["50%", -1]
ex <- ex[index]

## Now to just get back to the original scale of the distance the I'll
## multiply the fit$error results by the expected values. The result
## is then the crude difference in prevalance.

sum_fit <- lapply(fit, function(x) {
    lapply(seq_len(length(x$error)), function(y) {
        x$error[[y]] * as.numeric(ex[y])
    })
})

sum_fit <- lapply(seq_len(length(sum_fit[[1]])), function(x) {
    do.call("c", lapply(sum_fit, "[[", x))
})
