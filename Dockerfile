FROM python:3.9
COPY ./flask_app.py /
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
RUN rm /tmp/requirements.txt
CMD ["python", "flaskapp.py"]
