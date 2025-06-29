Run ollama
ollama llama3.1:latest 

Run ngrok
ngrok http --url=naturally-giving-chow.ngrok-free.app 8000

Run in ml-server folder
uvicorn main:app --host 0.0.0.0 --port 8000