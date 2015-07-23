forked: dev-captcha
===

CAPTCHA for actual programmers against script-kiddies.

Running via Docker
---

1. Build `docker build -t dev-captcha .`
2. Run `docker run -it dev-captcha`

Tech Stuff
---

- developed using `ruby 2.1`
- gems used: `json` & `curl`
- `team.json` retrieved via curl and
- members converted to`Member`object
- `Member` contains the filtering functions

Filters
---

- `self.filter(options)`- the main filtering function
- Implemented filters:
..*`self.filter_by_location(location)`
..*`self.filter_by_age(start, end)`
- Dynamic filters:
..* `self.filter_by_name(string)`
..* `self.filter_by_name_and_location(string, string)`
..* `self.filter_by_name_and_age(string, int)`
..* `self.filter_by_name_and_age(string, array[int, int])`
..* `self.filter_by_location(string)`
..* `self.filter_by_location_and_name(string, string)`
..* `self.filter_by_location_and_age(string, int)`
..* `self.filter_by_location_and_age(string, array[int, int])`

ErrorHandling
---

- returns `No method 'search' for class Member` when method is not implemented; only filter_by_* functions are dynamically created
- returns `Invalid method [method] with arguments [args]` when calling a filter_by_* method with invalid attribute/s


Todo
---

- handling of expressions in dynamic filters
- write an actual unit test

