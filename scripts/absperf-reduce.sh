#!/bin/sh

awk '
/^litmus-tests/ {
	curtest=$1;
	testran = 0;
}

/^Test/ {
	testran = 1;
}

/maxresident)k/ {
	if (testran) {
		curtesttime = $0;
		gsub(/user .*$/, "", curtesttime);
		testtime_n[curtest]++;
		testtime_sum[curtest] += curtesttime;
		if (testtime_max[curtest] == "" || curtesttime > testtime_max[curtest])
			testtime_max[curtest] = curtesttime;
		if (testtime_min[curtest] == "" || curtesttime < testtime_min[curtest])
			testtime_min[curtest] = curtesttime;
	}
}

END {
	for (i in testtime_n)
		print i, testtime_sum[i] / testtime_n[i], testtime_min[i], testtime_max[i];
}
'
