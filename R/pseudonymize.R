#' Pseudonymize columns in data containing PINs
#'
#' @param data A data frame containing PINs to be pseudonymized.
#' @param key Named vector or data frame, used as a lookup table for pids. If
#'   data frame, the first column is assumed to contain PINs and the second
#'   column the corresponding pids.
#' @param ... Manually selected columns to be pseudonymized. These are
#'   automatically quoted and evaluated in the context of the data. Uses
#'   `tidyselect` semantics for selection.
#' @param guess Logical. Attempt to automatically identify and pseudonymize
#'   columns that contain PINs?
#' @param replace Logical. Should PIN columns be replaced with the pseudonymized
#'   versions?
#' @param rename Logical or function. If `FALSE`, pseudonymized columns will
#'   not be automatically renamed; if `TRUE`, they will be suffixed with
#'   `"_pid"`; if a function, will be called on PIN column names to generate
#'   new names for the pseudonymized columns. Manually specified new names will
#'   always be used regardless.
#' @return A data frame where PINs have probably been linked to pids. If
#'   \code{replace = TRUE} values in columns guessed to have PINs have been
#'   replaced with matching pids from `key`.
#' @seealso \code{\link{is_probably_pin}} used to guess if columns contain PINs
#' @export
pseudonymize <- function(data, key, ..., guess = FALSE,
                         replace = TRUE, rename = !replace) {
  if (is.data.frame(key)) {
    key <- tibble::deframe(key)
  }

  nm <- names(data)
  manual <- tidyselect::vars_select(nm, ...)

  if (length(manual) == 0 && !guess) {
    warning("No columns selected to pseudonymize. ",
            "Did you forget to set `guess = TRUE`?",
            call. = FALSE, immediate. = TRUE)
    return(data)
  }

  is_pin <- nm %in% manual

  if (guess) {
    probably <- vapply(data, is_probably_pin, logical(1))
    is_pin <- is_pin | probably
  }

  pid_cols <- lapply(data[is_pin], map_to_named, key)

  new_nm <- names(tidyselect::vars_rename(nm, !!!manual))
  to_rename <- is_pin & new_nm == nm

  rename <- get_rename_fun(rename)
  new_nm[to_rename] <- rename(new_nm[to_rename])

  if (replace) {
    data[is_pin] <- pid_cols
    names(data) <- new_nm
  } else {
    pid_nm <- new_nm[is_pin]
    names(pid_cols) <- pid_nm

    pin_pos <- which(is_pin)
    data <- add_cols(data, pid_cols, pin_pos)
  }

  data
}

#' @rdname pseudonymize
pseudonymise <- pseudonymize

get_rename_fun <- function(rename) {
  if (is.logical(rename)) {
    stopifnot(!is.na(rename))
    if (rename) {
      rename <- function(x) paste0(x, "_pid")
    } else {
      rename <- base::identity
    }
  } else if (!is.function(rename)) {
    stop("`rename` must be logical or a function, not ",
         typeof(rename), call. = FALSE)
  }

  rename
}
