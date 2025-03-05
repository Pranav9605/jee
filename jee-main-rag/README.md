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
