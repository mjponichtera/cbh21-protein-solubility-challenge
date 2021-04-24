FROM python:3.8-slim
WORKDIR /home/biolib
COPY requirements.txt .
RUN pip install -r requirements.txt
RUN apt-get install dssp
RUN apt-get install build-essentials wget libjson0 libjson0-dev libxml2 libxml2-dev libxml2-utils autoconf automake libtool
RUN wget http://freesasa.github.io/freesasa-2.0.3.tar.gz
RUN tar -xzf freesasa-2.0.3.tar.gz
WORKDIR /opt/freesasa-2.0.3
RUN ./configure CFLAGS="-fPIC -O2" --prefix=`pwd` --disable-xml
RUN make
RUN make install

WORKDIR /opt
RUN rm freesasa-2.0.3.tar.gz

COPY wrapper.sh /opt/freesasa-2.0.3
COPY predict.py .
COPY data/test.zip data/
ENTRYPOINT ["python3", "predict.py"]
