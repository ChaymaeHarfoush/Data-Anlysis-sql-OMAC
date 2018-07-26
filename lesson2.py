
"""
Input: 
	numbers separated ny ','
Output: 
	list lenght
	Mode
	Range
	interquartile range
	Maximum
	Minimum
	Q1: the "middle" value in the first half of the rank-ordered data set.
	Q2: the median value in the set.
	Q3: the "middle" value in the second half of the rank-ordered data set.
	Mean
	standard deviation
	Variance
"""

import math

def medi(lst):
    if len(lst)%2:
        median=lst[math.floor(len(lst)/2)]       
    else:
        down=lst[math.floor(len(lst)/2)-1]
        up=lst[math.ceil(len(lst)/2)]
        median=(down+up)/2
        
    return median
    

x=input()
h=list(map(float,x.split(',')))
h.sort()
mode=dict()


maxi=max(h)
mini=min(h)
rang=maxi-mini
mean=sum(h)/len(h)
k=[]
for i in h:
    mode[i]=mode.get(i,0)+1
    k.append((i-mean)**2)
var=sum(k)/len(k)
standard=math.sqrt(var)



median=medi(h)
half_index=math.floor(len(h)/2)
if median in h:
    q1=medi(h[:half_index])
    q3=medi(h[half_index+1:])
else:
    q1=medi(h[:half_index])
    q3=medi(h[half_index-1:])
print('lenght= ',str(len(h)))
print('repetition= '+str(mode)) 
print('range= '+str(rang))
print('interquartile range= '+str(q3-q1))
print('min= '+str(mini))
print('max= '+str(maxi))
print('q1= '+str(q1))
print('q2= median = '+str(median))
print('q3= '+str(q3))
print('mean= '+str(mean))
print('standard deviation= ' + str(standard))
print('variance= '+str(var))
