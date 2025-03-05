from pydantic import BaseModel

class Question(BaseModel):
    question_text: str

class Answer(BaseModel):
    answer: str
