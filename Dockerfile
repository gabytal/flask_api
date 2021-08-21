FROM python:3.9
RUN mkdir /app
COPY . /app
RUN pip install -r /app/requirements.txt
CMD ["bin/bash", "ls /app"]
