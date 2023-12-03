#!/bin/bash
#
# Usage: sh ootavacuous.sh
#
# Commands:
#
# @@ DisplayLitmus path.litmus @@
#	Use c2latex.sh to squish the tabs and number the lines.
#	Note that "path.litmus" must not contain whitespace.
# @@ RunLitmus path.litmus @@
#	Use "herd7 -c11" to run the test, placing the output in
#	path.litmus.out, then use c2latex.sh to number the lines.
#	Note that "path.litmus" must not contain whitespace.

T="`mktemp -d ${TMPDIR-/tmp}/ootavacuous.sh.XXXXXX`"
trap 'rm -rf $T' 0

awk -v q="'" -v bs='\\' < ootavacuous.tex '
BEGIN {
	print "cat << '___EOF___'";
	print "% Automatically built, do not edit";
	print "%";
}

/^@@ DisplayLitmus .* @@$/ {
	path = $3;
	print "'___EOF___'";
	print "grep -v " q "^[( ]" bs "*" q " < " path " | c2latex.sh";
	print "cat << '___EOF___'";
	next;
}

/^@@ RunLitmus .* @@$/ {
	path = $3;
	print "'___EOF___'";
	print "herd7 -c11 " path " | c2latex.sh ";
	print "cat << '___EOF___'";
	next;
}

{
	print $0;
}

END {
	print "___EOF___";
}' | sh > ootavacuous-flat.tex

pdflatex ootavacuous-flat.tex
bibtex ootavacuous-flat.aux
pdflatex ootavacuous-flat.tex
pdflatex ootavacuous-flat.tex
