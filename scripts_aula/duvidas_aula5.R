base <- nycflights13::flights


base %>% 
  dplyr::mutate(
    data = lubridate::make_date(year, month, day)
  ) %>% 
  View()
