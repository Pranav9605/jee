from fastapi import FastAPI
from app.api.endpoints import qa, health

app = FastAPI(
    title="JEE Main RAG Q&A API",
    description="API for Retrieval-Augmented Generation (RAG) for answering JEE Main questions",
    version="1.0.0"
)

app.include_router(health.router)
app.include_router(qa.router)

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8000)
