# Builder PUBLICO do Blossom Tales -- Debian 10 (buster, glibc 2.28).
# Herda a imagem canonica glibc230 da casa e acrescenta so o compilador C++
# cross, exigido pelo decodificador AAC interno (FDK-AAC e' C++).
FROM nxextract-ui-builder:glibc230
RUN apt-get -o Acquire::Check-Valid-Until=false update \
 && apt-get install -y --no-install-recommends g++-8-aarch64-linux-gnu \
 && rm -rf /var/lib/apt/lists/*
