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
