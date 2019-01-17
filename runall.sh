date=$(date +%Y%m%d%H%M%S)
mv s1 's1_before_'$date
mkdir s1
cp s1-originalaperture/base.list s1/base.list
cp s1-originalaperture/config.sh s1/config.sh
cp s1-originalaperture/qdlp-extract.sh s1/qdlp-extract.sh
cp s1-originalaperture/x-lookup.sh s1/x-lookup.sh

cd s1 && ln -s /data/apal/astro/tess/process/s1/wcs wcs && cd ..
cd s1 && ln -s /data/apal/astro/tess/process/s1/fits fits && cd ..
cd s1 && ln -s /data/apal/astro/tess/process/s1/hint hint && cd ..

#pip install pandas

echo "import sys" > python1sec1.py
echo "import pandas as pd" >> python1sec1.py
echo "df=pd.read_csv(sys.argv[1],header=None,sep=',')" >> python1sec1.py
echo "gaiaIDs=df[0].tolist()" >> python1sec1.py
echo "RAlist=df[1].tolist()" >> python1sec1.py
echo "DEClist=df[2].tolist()" >> python1sec1.py
echo "refmag=df[3].tolist()" >> python1sec1.py
echo 'fout1 = open("s1/sector1photometry.sh","w")'  >> python1sec1.py
echo "for index, each in enumerate(gaiaIDs):" >> python1sec1.py
echo '    fout1.write("./qdlp-extract.sh -c "+str(RAlist[index])+","+str(DEClist[index])+" -S 1 -n "+str(each)+"S1lc"+" -r "+str(refmag[index])+"\n")' >> python1sec1.py
echo '    fout1.write("if [ -d "+str(each)+"S1lc"+" ]; then"+"\n")' >> python1sec1.py
echo '    fout1.write("cd "+str(each)+"S1lc && ./run-00-all.sh && cd .."+"\n")' >> python1sec1.py
echo '    fout1.write("fi"+"\n")' >> python1sec1.py
echo "fout1.close()" >> python1sec1.py


python python1sec1.py $1
chmod +x s1/sector1photometry.sh
(cd s1 && ./sector1photometry.sh)&
