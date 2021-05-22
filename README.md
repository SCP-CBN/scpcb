# CBN

The original game's source code can be found here: https://github.com/Regalis11/scpcb

The game is based on the works of the [SCP Foundation community][scp-wiki].

# Requirements:

Windows:
* [Visual Studio 2019][vs2019].

macOS:
* Mojave (10.14) or higher.
* Xcode 10.3 or higher.

# Before compiling:
* Make sure the Working Directory of the SCPCB project is set to `$(TargetDir)` (Configuration Properties -> Debugging).

# License
Licensing terms can be found in [License.txt](Content/License.txt).

# List of things to avoid doing in the game's code:

* Anything that isn't OTBS (Allman, GNU, etc).
* Omitting brackets when they can be used.
* Any language other than C or C++.
* Anything other than lower camelCase for functions and variables.
* Anything other than upper CamelCase for class/struct names or enum values.
* `using` directive for any namespace other than CBN.
* `using` directive in header files.
* `std::string`.
* Overriding virtual methods without the `override` or `final` keywords.
* `auto` keyword (unless using range-based for).
* `switch` `case`s that don't create a new scope.
* Tabs & indentations other than multiples of 4 spaces.
* Anything other than LF newlines.
* `#define` for anything but include safeguards.
* `#pragma once`.
* Text/source files without a newline at the end.
* Declaring several variables in one statement.
* Placing the pointer/reference symbol anywhere other than next to the type.
* Initialization lists (except when used to initialize a variable that needs to be `const`).

[openal]: https://www.openal.org/
[vs2019]: https://visualstudio.microsoft.com/vs/
[scp-wiki]: http://www.scp-wiki.net/
[cc3.0]: http://creativecommons.org/licenses/by-sa/3.0/
