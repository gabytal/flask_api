FROM python:3.9

COPY ./flask_app.py /

RUN pip install -r ./requirements.txt

CMD ["python", "flaskapp.py"]
