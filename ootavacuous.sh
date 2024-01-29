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
#	Use "herd7 -c11" to run the test, then use c2latex.sh
#	to number the lines.  Note that "path.litmus" must not
#	contain whitespace.
# @@ DisplayRunLitmus path.litmus @@
#	Why not both?  ;-)

T="`mktemp -d ${TMPDIR-/tmp}/ootavacuous.sh.XXXXXX`"
trap 'rm -rf $T' 0 2

awk -v sq="'" -v dq='"' -v bs='\\' < ootavacuous.tex '
BEGIN {
	print "cat << " sq "___EOF___" sq;
	print "% Automatically built, do not edit";
	print "%";
}

/^@@ DisplayLitmus .* @@$/ {
	path = $3;
	print "{";
	print bs "scriptsize";
	print bs "begin{verbatim}";
	print "___EOF___";
	print "grep -v " sq "^[(/ ]" bs "*" sq " < " path " | ./c2latex.sh";
	print "cat << " sq "___EOF___" sq;
	print bs "end{verbatim}";
	print "}";
	next;
}

/^@@ DisplayRunLitmus .* @@$/ {
	path = $3;
	print "{";
	print bs "scriptsize";
	print bs "begin{verbatim}";
	print "___EOF___";
	print "grep -v " sq "^[(/ ]" bs "*" sq " < " path " | ./c2latex.sh";
	print "cat << " sq "___EOF___" sq;
	print bs "end{verbatim}";
	print "";
	print "Analysis by " dq bs "co{herd7 -c11 " path dq "}:";
	print bs "begin{verbatim}";
	print "___EOF___";
	print "herd7 -c11 " path " | grep -v " sq "^$" sq " | ./c2latex.sh ";
	print "cat << " sq "___EOF___" sq;
	print bs "end{verbatim}";
	print "}";
	next;
}

/^@@ RunLitmus .* @@$/ {
	path = $3;
	print "{";
	print bs "scriptsize";
	print bs "begin{verbatim}";
	print "___EOF___";
	print "herd7 -c11 " path " | grep -v " sq "^$" sq " | ./c2latex.sh ";
	print "cat << " sq "___EOF___" sq;
	print bs "end{verbatim}";
	print "}";
	next;
}

{
	print $0;
}

END {
	print "___EOF___";
}' | sh > ootavacuous-flat.tex

svgfiles=`find . -name '*.svg' -print`
for i in $svgfiles
do
	basename="${i%.svg}"
	if test ! -f "$basename.pdf" -o "$basename.svg" -nt "$basename.pdf"
	then
		echo "$basename.svg -> $basename.pdf"
		XDG_RUNTIME_DIR=na DBUS_SESSION_BUS_ADDRESS=na inkscape -o $basename.pdf < $basename.svg
	fi
done

pdflatex ootavacuous-flat.tex
bibtex ootavacuous-flat.aux
pdflatex ootavacuous-flat.tex
pdflatex ootavacuous-flat.tex
cp ootavacuous-flat.pdf ootavacuous.pdf
