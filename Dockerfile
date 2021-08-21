FROM python:3.9

COPY ./flask_app.py /app

WORKDIR /app

RUN pip install -r requirements.txt

CMD ["python", "flaskapp.py"]
