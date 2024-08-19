#!/bin/bash
#
# litmus2table.sh whatever.litmus
#
# Outputs an abbreviated LaTeX table variant.

awk -v amp='&' -v bs='\\' -v dq='"' '
BEGIN {
	procnum = -1;
	stmtno = 0;
	memorder["memory_order_relaxed"] = "rlx";
	memorder["memory_order_acquire"] = "acq";
	memorder["memory_order_release"] = "rel";
}

inproc != 0 && $0 != "}" {
	stmt = $0;
	moa = $0;
	gsub(/	/, "~~", stmt);
	if (moa ~ /memory_order_/) {
		gsub(/^.*memory_order_/, "memory_order_", moa);
		gsub(/\);/, "", moa);
		moa = memorder[moa];
	}
	if (stmt ~ /= atomic_load_explicit\(/) {
		gsub(/= atomic_load_explicit\(/, "=" bs "textsubscript{" moa "} ", stmt);
		gsub(/, memory_order_[a-z_]*\);/, "", stmt);
	} else if (stmt != /atomic_store_explicit\(/) {
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
	inproc = 0;
}

END {
	cols = "r";
	head = "";
	for (i = 0; i <= procnum; i++) {
		cols = cols "|l";
		head = head "& P" i " ";
	}
	print bs "begin{tabular}{" cols "}"
	print head bs bs;
	print bs "hline"
	stmtno = 0;
	for (i in stmtlist) {
		tabs = "";
		printf "%d.", ++stmtno;
		for (j = 0; j <= procnum; j++) {
			printf " &\n%s", tabs stmtlist[i][j];
			tabs = tabs "	";
		}
		print " " bs bs;
	}
	print bs "end{tabular}"
}'
