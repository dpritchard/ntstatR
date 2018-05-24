statm <- function(safe, spp, habitat){
    # Test safe
    if (!is.numeric(safe) || length(safe) != 1){
        stop("safe must be a numeric vector of length 1.", call. = FALSE)
    }
    if (safe < 0 || safe > 4){
        stop("safe must be in the range 0 to 4")
    }
    # Test spp
    if(is.data.frame(spp)){
        tmp <- list()
        for(a in 1:nrow(spp)){
            tmp[[a]] <- as.list(spp[a,])
        }
        spp <- tmp
    }
    if(!list(spp)){
        stop("spp must be a list", call. = FALSE)
    }
    if(nrow(spp) < 1 || nrow(spp) > 5){
        stop("You must provide at least one, but no more than five, species.", call. = FALSE)
    }
    uis <- 1L
    for(a in seq_along(spp)){
        test_obj_names(spp[[a]])
        test_numeric(spp[[a]], what="replace")
        test_numeric(spp[[a]], what="getAFeed")
        test_numeric(spp[[a]], what="tasteCondition")
        if(is.null(spp[[a]]$name) || spp[[a]]$name ==""){
            spp[[a]]$name <- sprintf("Unknown Species %d", uis)
            uis <- uis + 1L
        }
    }
    # Test habitat
    if (!all(is.numeric(habitat)) || !(length(habitat) == 6)){
        stop("habitat must be a numeric vector of length 6")
    }
    if (any(na.omit(habitat) < -2) || any(na.omit(habitat) > 4)){
        stop("habitat values must be NAs or in the range -2 to 4")
    }
    # Could coerce negatives to NA here.. Otherwise the following will always pass:
    if (all(is.na(habitat))){
        stop("You must answer at least one of the questions on forms H and I")
    }

    # -1 and -2 mean NA in this context
    habitat[habitat < 0] <- NA

    # Calculate the habitat score (out of 4)
    habitat_score <- mean(habitat, na.rm=TRUE)

    # OK, begin calculation
    # Get the scores including species and habitat, ignoring site safety
    spp_out <- lapply(spp, get_species_scores, habitat = habitat_score, safe = safe)

    # Weight species for the final score:
    num_spp <- ifelse(test = is.null(nrow(spp)), yes = 1, no = nrow(spp))
    spp_weights <- statm_weight_spp(num_spp)

    scores <- sapply(spp_out, '[[', 'incl_saftey')
    scores_weighted <- cumsum(scores * spp_weights) / cumsum(spp_weights)
    ## In the XLS sheet, the final score is effectively the same as the last calculated cumulative average score (with some seriously complex if/elses!)
    ## Lets grab that...
    final_score <- tail(scores_weighted, n = 1)
    final_scoreR <- final_score / 192

    out <- list()
    out <- list("spp" = spp_out,
                "final" = list("score" = final_score,
                               "ratio" = final_scoreR))
    class(out) <- c("statm", class(out))
    return(out)
}

test_obj_names <- function(x){
    msg <- "All species objects / lists must have named items: 'replace', 'getAFeed' and  'tasteCondition'."
    if(is.null(names(x))){
        stop(msg, call. = FALSE)
    }
    has_req <- all(c("replace", "getAFeed", "tasteCondition") %in% names(x))
    if(!has_req){
        stop(msg, call. = FALSE)
    }
}

test_numeric <- function(x, what){
    if(length(x[[what]]) != 1L){
        stop("All answers to species questions must be a single value", call. = FALSE)
    }
    if(!is.numeric(x[[what]])){
        stop("All answers to species questions must be numeric", call. = FALSE)
    }
    if (x[[what]] < 0 || x[[what]] > 4){
        stop("All answers to species questions in the range 0 to 4")
    }
}

statm_weight_spp <- function(nspp){
    if (!is.numeric(nspp)){
        stop("nspp must be numeric")
    }
    weights <- 1 * exp(log(0.8) * (seq(1:nspp) - 1))
    return(weights)
}

get_species_scores <- function(x, habitat, safe){
    tmp <- list()
    tmp[['name']] <- x[['name']]
    tmp[['ex_saftey']] <- (x[['replace']] + x[['tasteCondition']] + habitat) * x[['getAFeed']]
    tmp[['ex_saftey_max']] <- 48
    tmp[['ex_saftey_ratio']] <- tmp[['ex_saftey']] / tmp[['ex_saftey_max']]
    tmp[['incl_saftey']] <- tmp[['ex_saftey']] * safe
    tmp[['incl_saftey_max']] <- 192
    tmp[['incl_saftey_ratio']] <- tmp[['incl_saftey']] / tmp[['incl_saftey_max']]
    return(tmp)
}

print.statm <- function(x, include_safe = TRUE, ...){
    cat(sprintf("Final score: %.0f (%.0f%%)\n", x$final$score, x$final$ratio*100))
    max_spp_len <- max(stringr::str_length(x$spp))+2
    if(include_safe){
        site_text <- "Including"
        sc <- x$including_safety
    } else {
        site_text <- "Excluding"
        sc <- x$excluding_safety
    }
    cat(sprintf("Species Scores (%s Site Health)\n", site_text))
    for(a in seq_along(sc$score)){
        cat("  ")
        cat(stringr::str_pad(paste0(x$spp[a],": "), max_spp_len, side="right"))
        cat(sprintf("%.0f (%.0f%%)\n", sc$score[a], sc$ratio[a]*100))
    }
}
