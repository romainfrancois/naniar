context("miss_var_summary tidiers")

test_that("miss_var_summary errors on NULL",{
  expect_error(miss_var_summary(NULL))
})

test_that("miss_var_summary errors when a non-dataframe given",{
  expect_error(miss_var_summary(1))
  expect_error(miss_var_summary("a"))
  expect_error(miss_var_summary(matrix(iris)))
})

test_that("miss_var_summary produces a data_frame", {
  expect_is(miss_var_summary(airquality), "tbl_df")
})

# group_by testing -------------------------------------------------------------

aq_group <- dplyr::group_by(airquality, Month)

test_that("miss_var_summary grouped_df returns a tibble", {
  expect_is(miss_var_summary(aq_group), "tbl_df")
})

test_that("miss_var_summary returns the right number of columns", {
  expect_equal(ncol(miss_var_summary(airquality)),
               3)
})

test_that("miss_var_summary group returns the right number of columns", {
  expect_equal(ncol(miss_var_summary(aq_group)),
               4)
})

test_that("grouped_df returns 1 more column than regular miss_var_summary", {
  expect_equal(ncol(miss_var_summary(aq_group)),
               ncol(miss_var_summary(airquality)) + 1)
})

test_that("grouped_df returns a column named 'Month'", {
  expect_identical(names(miss_var_summary(aq_group)),
                   c("Month", "variable", "n_miss","pct_miss"))
})

test_that("grouped_df returns a dataframe with more rows than regular", {
  expect_gt(nrow(miss_var_summary(aq_group)),
            nrow(miss_var_summary(airquality)))
})

test_that("grouped_df returns a column named 'Month' with the right levels", {
  expect_identical(unique(miss_var_summary(aq_group)$Month),
                   5:9)
})



# add testing for cumulative sum ----------------------------------------------

test_that("miss_var_summary adds cumsum when add_cumsum = TRUE", {
  expect_equal(names(miss_var_summary(airquality, add_cumsum = TRUE)),
               c("variable", "n_miss", "pct_miss", "n_miss_cumsum"))
})

test_that("miss_var_summary grouped adds cumsum when add_cumsum = TRUE", {
  expect_equal(names(miss_var_summary(aq_group, add_cumsum = TRUE)),
               c("Month", "variable", "n_miss", "pct_miss", "n_miss_cumsum"))
})
