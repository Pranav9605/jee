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
