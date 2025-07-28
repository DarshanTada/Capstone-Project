from fastapi import FastAPI, UploadFile, File
from pydantic import BaseModel
from typing import Optional
from rag_utils import load_and_embed, get_qa_chain
from llava_utils import query_llava
import shutil
import os

app = FastAPI()

class AskRequest(BaseModel):
    question: str
    system_prompt: Optional[str] = None
    image_base64: Optional[str] = None
    user_id: Optional[str] = None


@app.post("/upload/")
async def upload_file(file: UploadFile = File(...)):
    os.makedirs("data", exist_ok=True)
    path = f"data/{file.filename}"

    with open(path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    try:
        load_and_embed(path)
        return {"message": "File processed and embedded successfully"}
    except Exception as e:
        return {"error": f"Failed to embed file: {str(e)}"}


@app.post("/ask/")
async def ask_question(request: AskRequest):
    if request.image_base64:
        return query_llava(prompt=request.question, system=request.system_prompt, image=request.image_base64)

    chain = get_qa_chain(system_prompt=request.system_prompt)
    if chain:
        try:
            response = chain.run(request.question)
            return {"response": response}
        except Exception as e:
            print("[RAG fallback failed]", e)

    return query_llava(prompt=request.question, system=request.system_prompt)


@app.get("/health")
async def health_check():
    return {"status": "healthy", "message": "ML server is running"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
