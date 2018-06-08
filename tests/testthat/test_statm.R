context("Marine Assesment (statm)")

max_final <- 192
max_ex_safety <- 48
max_incl_saftey <- 192

test_that("returns a valid output object", {
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

    expect_equal(res$final$max, max_final)
    expect_equal(res$spp[[1]]$ex_saftey_max, max_ex_safety)
    expect_equal(res$spp[[1]]$incl_saftey_max, max_incl_saftey)

})

test_that("returns a 100% if everthing is at max", {
    spp <- list(list(replace = 4, getAFeed = 4, tasteCondition = 4))
    res <- statm(safe = 4, spp = spp, habitat = c(4,4,4,4,4,4))
    # Should be 100%
    expect_equal(res$final$score, max_final)
    expect_equal(res$final$ratio, 1)

    expect_equal(res$spp[[1]]$ex_saftey, max_ex_safety)
    expect_equal(res$spp[[1]]$ex_saftey_ratio, 1)

    expect_equal(res$spp[[1]]$incl_saftey, max_incl_saftey)
    expect_equal(res$spp[[1]]$incl_saftey_ratio, 1)
})


test_that("returns a zero final and include safety score if safe_to_eat is zero", {
    spp <- list(list(replace = 4, getAFeed = 4, tasteCondition = 4))
    res <- statm(safe = 0, spp = spp, habitat = c(4,4,4,4,4,4))
    # Final and species including safety should be zero
    expect_equal(res$final$score, 0)
    expect_equal(res$final$ratio, 0)
    expect_equal(res$spp[[1]]$incl_saftey, 0)
    expect_equal(res$spp[[1]]$incl_saftey_ratio, 0)
    # Excluding safety should be 100% still
    expect_equal(res$spp[[1]]$ex_saftey, max_ex_safety)
    expect_equal(res$spp[[1]]$ex_saftey_ratio, 1)
})


test_that("returns a complex two species score equal to the reference spreadsheet", {
    # MCHI Scoring and Analysis Sheet - March2013-V1 (NS)DP.xlsm
    spp <- list(list(replace = 2, getAFeed = 2, tasteCondition = 3),
                list(replace = 1, getAFeed = 3, tasteCondition = 2))
    res <- statm(safe = 2, spp = spp, habitat = c(3,3,3,3,3,3))
    # Test the final score is within rounding error
    expect_equal(res$final$score, 33.8, tolerance = .1, scale = 1)
    expect_equal(res$final$ratio, 33.8/max_final, tolerance = .1, scale = 1)

    expect_equal(res$spp[[1]]$incl_saftey, 32)
    expect_equal(res$spp[[1]]$incl_saftey_ratio, 32/max_incl_saftey)
    expect_equal(res$spp[[2]]$incl_saftey, 36)
    expect_equal(res$spp[[2]]$incl_saftey_ratio, 36/max_incl_saftey)

    expect_equal(res$spp[[1]]$ex_saftey, 16)
    expect_equal(res$spp[[1]]$ex_saftey_ratio, 16/max_ex_safety)
    expect_equal(res$spp[[2]]$ex_saftey, 18)
    expect_equal(res$spp[[2]]$ex_saftey_ratio, 18/max_ex_safety)

})


