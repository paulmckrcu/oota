#!/bin/bash
#
# litmus2table.sh whatever.litmus
#
# Outputs an abbreviated LaTeX table variant.

sed -e 's/&/\\&/' | sed -e 's/	}/	\\}/' | sed -e 's/{/\\{/' |
sed -e 's,\\/,$\\vee$,g' | sed -e 's,/\\,$\\wedge$,g' |
awk -v amp='&' -v bs='\\' -v dq='"' '
BEGIN {
	ininit = 0;
	inproc = 0;
	procnum = -1;
	stmtno = 0;
	memorder["memory_order_relaxed"] = "rlx";
	memorder["memory_order_acquire"] = "acq";
	memorder["memory_order_release"] = "rel";
}

ininit != 0 && $0 ~ /= *[[1-9]/ {
	curinit = $0;
	gsub(/\[/, "", curinit);
	gsub(/]/, "", curinit);
	gsub(/[	 ]/, "", curinit);
	initlist = initlist " " curinit;
}

procnum == -1 && /^{$/ {
	ininit = 1;
}

inproc != 0 && $0 != "}" {
	stmt = $0;
	moa = $0;
	gsub(/	/, "~~", stmt);
	if (moa ~ /memory_order_/) {
		gsub(/^.*memory_order_/, "memory_order_", moa);
		gsub(/\).*/, "", moa);
		moa = memorder[moa];
	}
	if (stmt ~ /= atomic_load_explicit\(/) {
		gsub(/= atomic_load_explicit\(/, "=" bs "textsubscript{" moa "} ", stmt);
		if (gsub(/, memory_order_[a-z_]*\);/, "", stmt) == 0)
			gsub(/, memory_order_[a-z_]*\)/, "", stmt);
	} else if (stmt ~ /atomic_store_explicit\(/) {
		gsub(/atomic_store_explicit\(/, "", stmt);
		gsub(/, memory_order_[a-z_]*\);/, "", stmt);
		gsub(/,/, " =" bs "textsubscript{" moa "}", stmt);
	}
	stmtlist[++stmtno][procnum] = stmt;
	# print procnum ":" stmtno, stmt
}

/^P[0-9]*/ {
	inproc = 1;
	stmtno = 0;
	procnum++;
}

/^}$/ {
	ininit = 0;
	inproc = 0;
}

/^exists/ {
	existsclause = $0;
	gsub(/^exists[ 	]*/, "", existsclause);
}

END {
	if (initlist != "")
		print "Non-zero initialization:" initlist;
	cols = "r";
	head = "";
	for (i = 0; i <= procnum; i++) {
		cols = cols "|l";
		head = head "& " bs "multicolumn{1}{c}{P" i "} ";
	}
	print bs "begin{tabular}{" cols "}"
	print head bs bs;
	print bs "hline"
	stmtno = 0;
	for (i in stmtlist) {
		tabs = "";
		printf "%d.", ++stmtno;
		for (j = 0; j <= procnum; j++) {
			printf " &\n%s", tabs bs "texttt{" stmtlist[i][j] "}";
			tabs = tabs "	";
		}
		print " " bs bs;
	}
	print bs "end{tabular}";
	if (existsclause != "") {
		print "";
		print bs "vspace{0.1in}";
		print "Condition " existsclause;
	}
}'
