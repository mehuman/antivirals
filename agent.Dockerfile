FROM ubuntu:20.04
LABEL maintainer="JJ Ben-Joseph (jbenjoseph@iqt.org)" \
      description="A antivirals agent container optimised for performance and minimal attack surface."
ARG DEBIAN_FRONTEND=noninteractive
ENTRYPOINT [ "antivirals" ] 
CMD [ "up" ]
COPY setup.py README.rst /app/
COPY antivirals /app/antivirals
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3-minimal python3-pip libopenblas0-openmp python3-rdkit \
      cython3 python3-dev build-essential cmake libopenblas-openmp-dev \
      gfortran libffi-dev \
 && CFLAGS="-g0 -O3 -Wl,--strip-all -I/usr/include:/usr/local/include -L/usr/lib:/usr/local/lib" \
    pip3 install --compile --no-cache-dir --global-option=build_ext \
       --global-option="-j 4" -e . \
 && apt-get remove -y python3-dev python3-pip build-essential cmake \
      libopenblas-openmp-dev gfortran libffi-dev \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* /tmp/*