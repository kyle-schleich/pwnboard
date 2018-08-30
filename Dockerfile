FROM tiangolo/uwsgi-nginx-flask:python3.6

EXPOSE 5000

# Install package dependencies
# RUN apk add --update python3 uwsgi
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --upgrade pip
RUN pip3 install -r /tmp/requirements.txt

# Install all the things
COPY app /app
