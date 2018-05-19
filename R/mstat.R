mstat <- function(safe, spp, habitat, names=NULL){
  if (!is.numeric(safe) || length(safe) != 1){
    stop("safe must be a numeric vector of length 1")
  }
  if (!all(is.numeric(spp)) || !any(ncol(spp) == 3, length(spp) == 3)){
    stop("spp must be a numeric matrix with 3 columns, or a numeric vector of length 3")
  }
  if (!all(is.numeric(habitat)) || !(length(habitat) == 6)){
    stop("habitat must be a numeric vector of length 6")
  }
  if (safe < 0 || safe > 4){
    stop("safe must be in the range 0 to 4")
  }
  if (any(spp < 0) || any(spp > 4)){
    stop("spp values must be in the range 0 to 4")
  }
  if (any(na.omit(habitat) < -2) || any(na.omit(habitat) > 4)){
    stop("habitat values must be NAs or in the range -2 to 4")
  }
  if (all(is.na(habitat))){
    stop("You must answer at least one of the questions on forms H and I")
  }
  if(!is.null(nrow(spp))){
    nspp <- nrow(spp)
  } else {
    nspp <- 1
  }
  if (!is.null(names)){
    if(!is.character(names)){
      stop("names must be a character vector")
    }
    if (length(names) != nspp){
      stop("names must have the same length as the number of rows in spp")
    }
  } else {
    if (!is.null(rownames(spp))){
        names <- rownames(spp)
    } else {
        names <- paste("Unknown Species", c(1:nspp))
    }
  }

  # -1 and -2 mean NA in this context
  habitat[habitat < 0] <- NA
  # Calculate the habitat score (out of 4)
  if (is.null(nrow(habitat))){
    habitat_score <- mean(habitat, na.rm=TRUE)
  } else {
    habitat_score <- rowMeans(habitat, na.rm=TRUE)
  }

  # OK, begin calculation
  # Get the scores including species and habitat, ignoring site safety
  if (is.null(nrow(spp)) || nrow(spp) == 1){
    scores_ex_safety <- (sum(spp[-2], na.rm=TRUE) + habitat_score) * spp[2]
  } else {
    scores_ex_safety <- (rowSums(spp[, -2], na.rm=TRUE) + habitat_score) * spp[, 2]
  }
  scores_ex_safetyR <- scores_ex_safety / 48

  # Now account for site safety:
  scores <- scores_ex_safety * safe
  scoresR <- scores / 192

  # Weight species for the final score:
  num_spp <- ifelse(test = is.null(nrow(spp)), yes = 1, no = nrow(spp))
  spp_weights <- mstat_weight_spp(num_spp)
  scores_weighted <- cumsum(scores * spp_weights) / cumsum(spp_weights)
  ## In the XLS sheet, the final score is effectively the same as the last calculated cumulative average score (with some seriously complex if/elses!)
  ## Lets grab that...
  final_score <- tail(scores_weighted, n = 1)
  final_scoreR <- final_score / 192

  out <- list()
  out <- list("spp" = names,
              "excluding_safety" = list("scores" = scores_ex_safety,
                                        "ratios" = scores_ex_safetyR),
              "including_safety" = list("scores" = scores,
                                        "ratios" = scoresR),
              "final_score" = final_score,
              "final_ratio" = final_scoreR)
  class(out) <- c("mstat", class(out))
  return(out)
}

mstat_weight_spp <- function(nspp){
  if (!is.numeric(nspp)){
    stop("nspp must be numeric")
  }
  weights <- 1 * exp(log(0.8) * (seq(1:nspp) - 1))
  return(weights)
}

print.mstat <- function(x, include_safe = TRUE, ...){
    cat(sprintf("Final score: %.0f (%.0f%%)\n", x$final_score, x$final_ratio*100))
    max_spp_len <- max(stringr::str_length(x$spp))+2
    if(include_safe){
        site_text <- "Including"
        sc <- x$including_safety
    } else {
        site_text <- "Excluding"
        sc <- x$excluding_safety
    }
    cat(sprintf("Species Scores (%s Site Health)\n", site_text))
    for(a in seq_along(sc$scores)){
        cat("  ")
        cat(stringr::str_pad(paste0(x$spp[a],": "), max_spp_len, side="right"))
        cat(sprintf("%.0f (%.0f%%)\n", sc$scores[a], sc$ratios[a]*100))
    }
}
