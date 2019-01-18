date=$(date +%Y%m%d%H%M%S)
mv s2 's2_before_'$date
mkdir s2
cp s2-originalaperture/base.cadence s2/base.cadence
cp s2-originalaperture/base.list s2/base.list
cp s2-originalaperture/base.orbit s2/base.orbit
cp s2-originalaperture/base.qual s2/base.qual
cp s2-originalaperture/config.sh s2/config.sh
cp s2-originalaperture/qdlp-extract.sh s2/qdlp-extract.sh
cp s2-originalaperture/x-lookup.sh s2/x-lookup.sh

cd s2 && ln -s /data/apal/astro/tess/process/s2/wcs wcs && cd ..
cd s2 && ln -s /data/apal/astro/tess/process/s2/fits fits && cd ..
cd s2 && ln -s /data/apal/astro/tess/process/s2/hint hint && cd ..

echo "import sys" > python1sec2.py
echo "import pandas as pd" >> python1sec2.py
echo "df=pd.read_csv(sys.argv[1],header=None,sep=',')" >> python1sec2.py
echo "gaiaIDs=df[0].tolist()" >> python1sec2.py
echo "RAlist=df[1].tolist()" >> python1sec2.py
echo "DEClist=df[2].tolist()" >> python1sec2.py
echo "refmag=df[3].tolist()" >> python1sec2.py
echo 'fout1 = open("s2/sector2photometry.sh","w")'  >> python1sec2.py
echo "for index, each in enumerate(gaiaIDs):" >> python1sec2.py
echo '    fout1.write("./qdlp-extract.sh -c "+str(RAlist[index])+","+str(DEClist[index])+" -S 2 -n "+str(each)+"S2lc"+" -r "+str(refmag[index])+"\n")' >> python1sec2.py
echo '    fout1.write("if [ -d "+str(each)+"S2lc"+" ]; then"+"\n")' >> python1sec2.py
echo '    fout1.write("cd "+str(each)+"S2lc && ./run-00-all.sh && cd .."+"\n")' >> python1sec2.py
echo '    fout1.write("fi"+"\n")' >> python1sec2.py
echo "fout1.close()" >> python1sec2.py

python python1sec2.py $1
chmod +x s2/sector2photometry.sh
(cd s2 && ./sector2photometry.sh)&
