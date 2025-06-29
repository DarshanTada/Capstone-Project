from fastapi import FastAPI, UploadFile, File, Form
from fastapi.responses import JSONResponse
from rag_utils import load_and_embed, get_qa_chain
import os

app = FastAPI()

@app.post("/upload/")
async def upload_file(file: UploadFile = File(...)):
    file_path = f"data/{file.filename}"
    with open(file_path, "wb") as f:
        f.write(await file.read())

    load_and_embed(file_path)
    return {"status": "File processed and embedded."}

@app.post("/ask/")
async def ask_question(question: str = Form(...), system_prompt: str = Form(None)):
    chain = get_qa_chain(system_prompt)
    if not chain:
        return JSONResponse(
            content={"error": "Model loading failed. Please ensure Ollama is running and the model is installed."},
            status_code=500
        )

    try:
        response = chain.run(question)
        return JSONResponse(content={"response": response})
    except Exception as e:
        return JSONResponse(content={"error": f"Model inference failed: {str(e)}"}, status_code=500)
