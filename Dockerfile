FROM debian:latest as builder

# Build tk4 docker with jcc and rdrprep installed
RUN apt update && apt install -yq unzip git build-essential
WORKDIR /tk4-/
ADD http://wotho.ethz.ch/tk4-/tk4-_v1.00_current.zip /tk4-/
RUN unzip tk4-_v1.00_current.zip && \
    rm -rf /tk4-/tk4-_v1.00_current.zip
#RUN echo "CONSOLE">/tk4-/unattended/mode
RUN rm -rf /tk4-/hercules/darwin && \
    rm -rf /tk4-/hercules/windows && \
    rm -rf /tk4-/hercules/source
RUN echo "sh echo 'DONE' >> /tk4-/done_tk4_jcc.txt" >> scripts/tk4-.rc
RUN echo "detach C" >> local_scripts/01 && \
    echo "pause 1" >> local_scripts/01 && \
    echo "attach C 3505 3506 sockdev ebcdic trunc eof" >> local_scripts/01

WORKDIR /
RUN git clone --depth 1 https://github.com/mvslovers/jcc.git
RUN git clone --depth 1 https://github.com/mvslovers/rdrprep.git
WORKDIR rdrprep
RUN make && make install


# Deploy
FROM debian:latest
MAINTAINER Phil Young - mainframed767
LABEL version="0.1"
LABEL description="tk4- Current with jcc and rdrprep"
RUN apt update && apt install -yq zip wget curl ftp build-essential netcat git

WORKDIR /
COPY --from=builder /jcc/ /jcc/
COPY --from=builder /usr/local/bin/rdrprep /usr/local/bin/rdrprep

WORKDIR /tk4-/
COPY --from=builder /tk4-/ .
COPY tk4_loaded.sh .
RUN chmod +x tk4_loaded.sh
VOLUME [ "/tk4-/conf","/tk4-/local_conf","/tk4-/local_scripts","/tk4-/prt","/tk4-/dasd","/tk4-/pch","/tk4-/jcl","tk4-/log" ]
CMD ["./mvs"]
EXPOSE 3270 8038 3505
