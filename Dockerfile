FROM python:3.9
WORKDIR /usr/src/app
COPY . ./
RUN pip install -r requirements.txt
CMD [ "python", "./flask_app.py" ]
