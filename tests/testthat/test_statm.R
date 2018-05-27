context("Marine Assesment (statm)")

test_that("statm returns a valid output object", {
    spp <- list(list(replace = 4, getAFeed = 4, tasteCondition = 4))
    res <- statm(safe = 4, spp = spp, habitat = c(4,4,4,4,4,4))
    expect_s3_class(res, 'statm')
    expect_type(res, 'list')
    expect_type(res$spp, 'list')
    expect_type(res$final, 'list')
    expect_named(res, c('spp', 'final'))
    spp_names <- c('name',
                   'ex_saftey', 'ex_saftey_max', 'ex_saftey_ratio',
                   'incl_saftey', 'incl_saftey_max', 'incl_saftey_ratio')
    expect_named(res$spp[[1]], spp_names)
    expect_named(res$final, c('score', 'max', 'ratio'))
    expect_length(res, 2)
    expect_length(res$spp, 1)
    expect_length(res$spp[[1]], 7)
    expect_length(res$final, 3)
})

test_that("statm returns a 100% final score", {
    spp <- list(list(replace = 4, getAFeed = 4, tasteCondition = 4))
    res <- statm(safe = 4, spp = spp, habitat = c(4,4,4,4,4,4))
    expect_equal(res$final$score, 192)
    expect_equal(res$final$max, 192)
    expect_equal(res$final$ratio, 1)

    expect_equal(res$spp[[1]]$ex_saftey, 48)
    expect_equal(res$spp[[1]]$ex_saftey_max, 48)
    expect_equal(res$spp[[1]]$ex_saftey_ratio, 1)
    expect_equal(res$spp[[1]]$incl_saftey, 192)
    expect_equal(res$spp[[1]]$incl_saftey_max, 192)
    expect_equal(res$spp[[1]]$incl_saftey_ratio, 1)
})
