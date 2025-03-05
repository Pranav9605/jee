#!/bin/bash

# Base directory for the project
BASE_DIR="jee-main-rag"

echo "Creating project directories..."

# Create main directories and subdirectories
mkdir -p $BASE_DIR/backend/app/core
mkdir -p $BASE_DIR/backend/app/api/endpoints
mkdir -p $BASE_DIR/backend/app/models
mkdir -p $BASE_DIR/backend/tests
mkdir -p $BASE_DIR/frontend/app/pages
mkdir -p $BASE_DIR/frontend/tests
mkdir -p $BASE_DIR/data
mkdir -p $BASE_DIR/deployment

###########################################
# Backend Files (FastAPI)
###########################################

echo "Creating backend files..."

# backend/app/main.py - FastAPI entry point with OpenAPI docs
cat <<'EOF' > $BASE_DIR/backend/app/main.py
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
EOF

# backend/app/api/endpoints/health.py - Health check endpoint
cat <<'EOF' > $BASE_DIR/backend/app/api/endpoints/health.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/health", tags=["Health"])
async def health_check():
    return {"status": "ok"}
EOF

# backend/app/api/endpoints/qa.py - Q&A endpoint with sample RAG logic
cat <<'EOF' > $BASE_DIR/backend/app/api/endpoints/qa.py
from fastapi import APIRouter, HTTPException
from app.models.schemas import Question, Answer
from app.core.rag_service import get_answer

router = APIRouter()

@router.post("/qa", response_model=Answer, tags=["Q&A"])
async def ask_question(question: Question):
    try:
        answer_text = get_answer(question.question_text)
        return Answer(answer=answer_text)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
EOF

# backend/app/models/schemas.py - Pydantic models for requests/responses
cat <<'EOF' > $BASE_DIR/backend/app/models/schemas.py
from pydantic import BaseModel

class Question(BaseModel):
    question_text: str

class Answer(BaseModel):
    answer: str
EOF

# backend/app/core/rag_service.py - Placeholder logic for RAG
cat <<'EOF' > $BASE_DIR/backend/app/core/rag_service.py
def get_answer(question_text: str) -> str:
    # Placeholder for retrieval augmented generation logic.
    # Replace this with your actual model or logic.
    return f"Answer for: {question_text}"
EOF

# backend/app/core/config.py - Configuration settings (if needed)
cat <<'EOF' > $BASE_DIR/backend/app/core/config.py
# Configuration settings for the JEE Main RAG Q&A API
API_TITLE = "JEE Main RAG Q&A API"
API_VERSION = "1.0.0"
EOF

# backend/app/requirements.txt - Dependencies for the backend
cat <<'EOF' > $BASE_DIR/backend/app/requirements.txt
fastapi
uvicorn
pydantic
EOF

# backend/app/Dockerfile - Dockerfile for the FastAPI backend
cat <<'EOF' > $BASE_DIR/backend/app/Dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF

###########################################
# Frontend Files (Streamlit)
###########################################

echo "Creating frontend files..."

# frontend/app/main.py - Streamlit app that calls the FastAPI endpoint
cat <<'EOF' > $BASE_DIR/frontend/app/main.py
import streamlit as st
import requests

st.title("JEE Main RAG Question Answering")

question = st.text_input("Enter your JEE Main question:")

if st.button("Get Answer"):
    if question:
        try:
            # Assumes the backend is running on localhost:8000
            response = requests.post("http://localhost:8000/qa", json={"question_text": question})
            if response.status_code == 200:
                answer = response.json().get("answer")
                st.success(f"Answer: {answer}")
            else:
                st.error("Error fetching answer from the API.")
        except Exception as e:
            st.error(f"Error: {e}")
    else:
        st.warning("Please enter a question.")
EOF

# frontend/app/requirements.txt - Dependencies for the frontend
cat <<'EOF' > $BASE_DIR/frontend/app/requirements.txt
streamlit
requests
EOF

# frontend/Dockerfile - Dockerfile for the Streamlit frontend
cat <<'EOF' > $BASE_DIR/frontend/Dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app/ .
CMD ["streamlit", "run", "main.py", "--server.port=8501", "--server.address=0.0.0.0"]
EOF

###########################################
# Deployment Files
###########################################

echo "Creating deployment files..."

# deployment/docker-compose.yml - Docker Compose for development
cat <<'EOF' > $BASE_DIR/deployment/docker-compose.yml
version: '3.8'

services:
  backend:
    build:
      context: ../backend/app
    ports:
      - "8000:8000"
    env_file:
      - ../.env
  frontend:
    build:
      context: ../frontend
    ports:
      - "8501:8501"
    env_file:
      - ../.env
EOF

# deployment/docker-compose.prod.yml - Docker Compose for production
cat <<'EOF' > $BASE_DIR/deployment/docker-compose.prod.yml
version: '3.8'

services:
  backend:
    build:
      context: ../backend/app
    ports:
      - "8000:8000"
    env_file:
      - ./.env.production
    restart: always

  frontend:
    build:
      context: ../frontend
    ports:
      - "8501:8501"
    env_file:
      - ./.env.production
    restart: always
EOF

# deployment/.env.production - Production environment variables
cat <<'EOF' > $BASE_DIR/deployment/.env.production
# Production Environment Variables

# FastAPI settings
API_TITLE=JEE Main RAG Q&A API
API_VERSION=1.0.0

# Add production-specific variables here (e.g., database URLs, API keys, etc.)
EOF

# Root-level .env - Development environment variables
cat <<'EOF' > $BASE_DIR/.env
# Common Environment Variables (Development)

# FastAPI settings
API_TITLE=JEE Main RAG Q&A API
API_VERSION=1.0.0
EOF

# deployment/README-deployment.md - Instructions for deployment
cat <<'EOF' > $BASE_DIR/deployment/README-deployment.md
# Deployment Instructions for JEE Main RAG Q&A Project

This project uses Docker Compose for both development and production deployments.

## Development

1. Navigate to the deployment folder:
   \`\`\`sh
   cd deployment
   \`\`\`
2. Run the following command to start the containers:
   \`\`\`sh
   docker-compose up --build
   \`\`\`
3. Access the FastAPI backend at [http://localhost:8000/docs](http://localhost:8000/docs) and the Streamlit frontend at [http://localhost:8501](http://localhost:8501).

## Production

1. Navigate to the deployment folder:
   \`\`\`sh
   cd deployment
   \`\`\`
2. Run the following command to start the containers with production settings:
   \`\`\`sh
   docker-compose -f docker-compose.prod.yml up --build -d
   \`\`\`
3. Update the production environment variables in \`deployment/.env.production\` as needed.
EOF

###########################################
# Root-Level README
###########################################

echo "Creating root-level README..."

cat <<'EOF' > $BASE_DIR/README.md
# JEE Main RAG Q&A Project

This project implements a Retrieval-Augmented Generation (RAG) system for answering JEE Main questions.

## Project Structure

- **backend/**: Contains the FastAPI-based API with sample endpoints and a placeholder RAG service.
- **frontend/**: Contains the Streamlit-based user interface to interact with the API.
- **data/**: Directory for storing PDFs or other data.
- **deployment/**: Contains Docker Compose files and environment files for deployment.
- **.env**: Common environment variables for development.

## Running the Project

### Development

1. Navigate to the \`deployment\` folder:
   \`\`\`sh
   cd deployment
   \`\`\`
2. Start the services:
   \`\`\`sh
   docker-compose up --build
   \`\`\`
3. Access:
   - API docs at [http://localhost:8000/docs](http://localhost:8000/docs)
   - Streamlit app at [http://localhost:8501](http://localhost:8501)

### Production

1. Navigate to the \`deployment\` folder:
   \`\`\`sh
   cd deployment
   \`\`\`
2. Start the services with production configuration:
   \`\`\`sh
   docker-compose -f docker-compose.prod.yml up --build -d
   \`\`\`
3. Update the production environment variables in \`deployment/.env.production\` as needed.
EOF

echo "Project structure for 'jee-main-rag' created successfully!"
