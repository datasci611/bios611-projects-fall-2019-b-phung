App found [here](https://bphung.shinyapps.io/project_2/).

This app allows the user to input a `Client File Number` and returns a graph of their visits, along with a graph of the Durham unemployment rate.

It would probably be most interesting to check out clients that have logged many visits, so here are the top five: 3502, 805, 738, 1176, and 904.

Possible future updates include:
* Switching to a different layout, in which the graphs take up the full width of the screen.
* Trying a different input widget. Although a dropdown menu might be very natural option to ensure that there will only be valid inputs, note that there are 15344 unique clients. Maybe have a way to find clients of interest.
* If there is no input, display the aggregate visits.
* Return an error message for invalid inputs.
* Implementing help text into the app itself.
* Add another output giving a summary of the client, such as their total number of visits, first and last visits, average time between visits, total services provided to.
