# Cities List
Test project, more about it in [Instructions](Instructions.md)

## About git

> The code of the assignment has to be delivered along with the git repository (.git folder).
We want to see the progress evolution

Commits in `git` doesn't display code evolution 100%: they don't contain experiments, intermediate commits etc. This is my general approach to version-control, I try to commit my code as much as possible into one big commit and when some parts are ready (single class for example), then I split big commit into smaller ones.

This is why you will see that most of the commits are dated within 10 minutes time frame - I was cleaning up the code, moving changes around git by splitting and squashing commits.

Also, I didn't use a gitflow, because I didn't find it necessary to do for such small project.

## Checklist

- [x] Load the list of cities from [here](cities.json).
- [x] Be able to filter the results by a given prefix string, following these requirements:
	- [x] Follow the prefix definition specified in the clarifications section below.
	- [x] Implement a search algorithm optimised for fast runtime searches. Initial loading time of the app does not matter.
	- [x] Search is case insensitive.
	- [x] **Time efficiency for filter algorithm should be better than linear**
- [x] Display these cities in a scrollable list, in alphabetical order (city first, country after). Hence, "Denver, US" should appear before "Sydney, Australia".
- [x] The UI should be as responsive as possible while typing in a filter.
- [x] The list should be updated with every character added/removed to/from the filter.
- [x] Each city's cell should:
	- [x] Show the city and country code as title.
	- [x] Show the coordinates as subtitle.
	- [x] When tapped, show the location of that city on a map.
- [x] Provide unit tests showing that your search algorithm is displaying the correct results giving different inputs, including invalid inputs.
- [x] You can preprocess the list into any other representation that you consider more efficient for searches and display. Provide information of why that representation is more efficient in the comments of the code.
- [x] Compatible with the 2 latest versions of iOS.
- [x] No 3rd party libraries.
- [x] The code of the assignment has to be delivered along with the git repository (.git folder).
