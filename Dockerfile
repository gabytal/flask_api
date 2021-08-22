FROM python:3.9
WORKDIR /usr/src/app
COPY flask_app.py requirements.txt ./
RUN pip install -r requirements.txt && rm requirements.txt
CMD [ "python", "./flask_app.py" ]
