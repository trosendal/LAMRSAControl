library(LAMRSAControl)
load("runfit.Rda")

## the order of the values in the MRSA_distance results are as
## follows. I will reorder to expect vector to be the same:
index <- c("q_m1s", "q_m2s", "q_m3s", "q_m2p", "q_m3p", "q_m4p", "q_m5p", "q_m6p")
ex <- MRSA_expected()["50%", -1]
ex <- ex[index]

## Now to just get back to the original scale of the distance the I'll
## multiply the fit$error results by the expected values. The result
## is then the crude difference in prevalance. Where a positive value
## is means the Broens values are higher than the model and negative
## values means the model is higher than Broens.

sum_fit <- lapply(fit, function(x) {
    lapply(seq_len(length(x$error)), function(y) {
        x$error[[y]] * as.numeric(ex[y])
    })
})

sum_fit <- lapply(seq_len(length(sum_fit[[1]])), function(x) {
    do.call("c", lapply(sum_fit, "[[", x))
})
names(sum_fit) <- index

titles <- c(q_m1s = "Sows when they enter the farrowing unit",
            q_m2s = "sows three days after entering the farrowing unit",
            q_m2p = "Piglets three days after entering the farrowing unit",
            q_m3s = "Sows three weeks after entering the farrowing unit",
            q_m3p = "Piglets three weeks after entering the farrowing unit",
            q_m4p = "Pigs 7 days after weaning",
            q_m5p = "Pigs 35 days after weaning",
            q_m6p = "Pigs 84 days after moving the the finishing unit")

pdf("modelfit.pdf", width = 12, height = 16)
par(mfrow = c(4, 2))
for (i in seq_len(length(sum_fit))) {
    ## Swap the sign of sum_fit to get Model result - expected from Broens
    plot(density(-sum_fit[[i]]),
         main = titles[names(sum_fit)[i]],
         xlab = "Model result - expected prevalence")
}
dev.off()
