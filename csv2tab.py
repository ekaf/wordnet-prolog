from os import listdir
from csv import reader

for csvfile in filter(lambda x: x[-4:]=='.csv', listdir('.')):
    f1=open(csvfile, 'r')
    f2=open(csvfile[:-4]+".tab", 'w')
    f2.write('\n'.join(['\t'.join(row) for row in reader(f1, delimiter=',', quotechar='\'')])+'\n')
    f1.close()
    f2.close()
