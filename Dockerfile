from continuumio/miniconda3:latest

ARG config_dir=/tmp/
ADD file.conf $config_dir

WORKDIR $config_dir

RUN pip install --upgrade pip && \
	pip install numpy pandas scikit-learn scipy textblob nltk vaderSentiment && \
	pip install reverse_geocoder geopy && \
        pip install tabpy

RUN tabpy-user-management add -u <username> -p <password> -f pwd.txt

ENV PORT 8080 
EXPOSE 8080

ENTRYPOINT tabpy --config=file.conf
