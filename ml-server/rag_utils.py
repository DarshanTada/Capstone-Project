# rag_utils.py

from langchain.embeddings import SentenceTransformerEmbeddings
from langchain.vectorstores import FAISS
from langchain.document_loaders import (
    PyPDFLoader, TextLoader, CSVLoader, UnstructuredWordDocumentLoader
)
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.chains import RetrievalQA
from langchain.llms import Ollama

embeddings = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")

def load_and_embed(file_path):
    if file_path.endswith(".pdf"):
        loader = PyPDFLoader(file_path)
    elif file_path.endswith(".csv"):
        loader = CSVLoader(file_path)
    elif file_path.endswith(".docx"):
        loader = UnstructuredWordDocumentLoader(file_path)
    else:
        loader = TextLoader(file_path)

    docs = loader.load()
    splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=100)
    split_docs = splitter.split_documents(docs)

    vectorstore = FAISS.from_documents(split_docs, embeddings)
    vectorstore.save_local("vector_store")
    return vectorstore

def get_qa_chain(system_prompt=None):
    from langchain.llms import Ollama
    from langchain.chains import RetrievalQA
    from langchain.vectorstores import FAISS

    try:
        vectorstore = FAISS.load_local("vector_store", embeddings, allow_dangerous_deserialization=True)
        retriever = vectorstore.as_retriever()

        llm = Ollama(model="llama3.1:latest", base_url="http://localhost:11434")
        if system_prompt:
            llm = Ollama(model="llama3.1:latest", base_url="http://localhost:11434", system=system_prompt)

        chain = RetrievalQA.from_chain_type(llm=llm, retriever=retriever)
        return chain

    except Exception as e:
        print(f"[ERROR: Ollama model failed] {e}")
        return None

