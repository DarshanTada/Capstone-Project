Install
Python 3.10.11 https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe

Rust https://rustup.rs/

Visual Studio Build Tools https://aka.ms/vs/17/release/vs_BuildTools.exe

Run ollama
ollama llama3.1:latest 

Run ngrok
ngrok http --url=naturally-giving-chow.ngrok-free.app 8000

Run in ml-server folder
uvicorn main:app --host 0.0.0.0 --port 8000
