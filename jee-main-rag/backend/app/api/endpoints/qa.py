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
