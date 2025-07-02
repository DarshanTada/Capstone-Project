from langchain.embeddings import SentenceTransformerEmbeddings
from langchain.vectorstores import FAISS
from langchain.document_loaders import (
    PyPDFLoader, TextLoader, CSVLoader, UnstructuredWordDocumentLoader
)
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.chains import RetrievalQA
from langchain.llms import Ollama
import os

embeddings = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")

def load_and_embed(file_path: str):
    ext = file_path.split(".")[-1].lower()
    if ext == "pdf":
        loader = PyPDFLoader(file_path)
    elif ext == "csv":
        loader = CSVLoader(file_path)
    elif ext == "docx":
        loader = UnstructuredWordDocumentLoader(file_path)
    else:
        loader = TextLoader(file_path)

    docs = loader.load()
    splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=100)
    chunks = splitter.split_documents(docs)

    vectorstore = FAISS.from_documents(chunks, embeddings)
    vectorstore.save_local("vector_store")
    return vectorstore


def get_qa_chain(system_prompt: str = None):
    try:
        vectorstore = FAISS.load_local("vector_store", embeddings, allow_dangerous_deserialization=True)
        retriever = vectorstore.as_retriever()

        llm = Ollama(
            model="llama3",
            base_url="http://localhost:11434",
            system=system_prompt
        )

        return RetrievalQA.from_chain_type(llm=llm, retriever=retriever)
    except Exception as e:
        print("[get_qa_chain error]", e)
        return None
