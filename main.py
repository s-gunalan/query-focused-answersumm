import datetime
import flask
from bs4 import BeautifulSoup
import requests
from flask import Flask, request, jsonify, render_template, redirect
from model.qsumm import *
from auth.oauth import *
import json
import tempfile

app = Flask(__name__)

ALLOWED_EXTENSIONS = {'txt'}
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route("/")
def root():
    return render_template("index.html")

@app.route("/query",methods=['POST'])
def query():
    if  request.method == "POST":
       # getting input with name = fname in HTML form
       query = request.form.get("question")
       #try:
       bot_response = jsonify(service.ask(query))
       print(bot_response)
       #except:
       #    bot_response = {'result':'Oops. Unexpected Error Occured.'}
    return bot_response

@app.route("/load_db_file",methods=['POST'])
def loadfile():
    if  request.method == "POST":
        print("::::::::load db file ::::::::")
        uploaded_file = request.files['srcfile']
        tempdir = tempfile.mkdtemp()

        if uploaded_file and allowed_file(uploaded_file.filename):
            with tempfile.TemporaryDirectory() as temp_dir:
                # Save the uploaded file to the temporary directory
                temp_file_path = os.path.join(temp_dir, uploaded_file.filename)
                uploaded_file.save(temp_file_path)
                service.load_db(temp_file_path,'')
            return redirect('/')    
    return redirect('/')

@app.route("/load_db_hc",methods=['POST'])
def helpcenter():
    if  request.method == "POST":
        print(request.form)
        web_url = request.form['web_url']
        response = requests.request("GET", web_url)
        print(response.content)
        soup = BeautifulSoup(response.content,"html.parser")
        text_content = soup.get_text()
        print('TEXTcontent'+text_content)
        # Create a temporary file to store the text content
        with tempfile.NamedTemporaryFile() as temp_file:
            temp_file.write(text_content.encode('utf-8'))
            temp_file_path = temp_file.name
            service.load_db(temp_file_path,web_url)
            print(temp_file)
    return redirect('/')



if __name__ == "__main__":
    print("JJJJJJ")
    # Langchain based JSON loader to load dataset in JSON Lines format
    dataset_path = 'dataset/validation.jsonl'
    from langchain.document_loaders import JSONLoader
    loader = JSONLoader(
        file_path=dataset_path,
        jq_schema='.answers[].sents[].text',
        text_content=False,
        json_lines=True)

    data = loader.load()
    service = QueryAnsweringService()
    service.initialize_service(data)
    #service.initialize_chroma(data)
    print(data[:5])
    app.run(host="127.0.0.1", port=8084, debug=True)