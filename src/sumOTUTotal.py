#!/usr/bin/env python
import sys
import re
import numpy as np

sys.argv.pop(0)

otus_all,out_file = sys.argv

sample_otus = {}
total_otu = 0

f = open(otus_all)
for line in f:
    tabs =  line.strip().split('\t')
    otu_name = tabs.pop(0)
    sample_set = set()
    for tab in tabs:
        sample_name = re.search('(\S+)_\d+',tab).group(1)
        if sample_name not in sample_otus:
            sample_otus[sample_name] = 0
        sample_set.add(sample_name)
    for sample in sample_set:
        sample_otus[sample] += 1
    total_otu += 1

a = np.array(list(sample_otus.itervalues()),dtype='int32')

sample_num = len(a)
average = np.mean(a)
std = np.std(a)

out = open(out_file,'w')
out.write('Sample Number:\t%s\n'%sample_num)
out.write('Total otus:\t%s\n'%total_otu)
out.write('otus average:\t%s\n'%average)
out.write('otus std:\t%s\n'%std)


