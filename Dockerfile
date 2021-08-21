FROM python:3.9
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
RUN rm /tmp/requirements.txt
CMD ["python", "flaskapp.py"]
