# jekyll_snippet
A jekyll plugin for adding snippets of code from a file

## Usage

Adding the snippet.rb file to the _plugin directory makes it possible to have code snippet highlighting, where code is stored in files. Documenting examples become a lot easier this way.

Snippet is called from liquid with the following options:
 * `src:<file>`: The file from which the code comes (Required)
 * `lang:<lang>`: The language (Required)
 * `linenos`: Display line numbers (Optional)
 * `lines:<start>-<stop>`: Show only line start till stop from the file (Optional)
 * `tag:<tagname>`: Show the code lines between `[snippet:<tagname> start]` and `[snippet:<tagname> stop]` from the given file.

The plugin reads in the file (or part of), and passes this to the jekyll highlighter.
