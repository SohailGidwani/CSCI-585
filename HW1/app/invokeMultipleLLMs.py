import streamlit as st
from litellm import completion
from pathlib import Path

# set up the Streamlit app
st.title("Multi-LLM prompting")

# create a text input for user messages
user_input = st.text_area("Prompt:", height=300)

if st.button("Send"):
        if user_input:
            messages = [{"role": "user", "content": user_input}]

            # columns for side-by-side display
            col1, col2 = st.columns(2)

            # first
            with col1:
                st.subheader("llama3")
                try:
                    response = completion(model="ollama/llama3", messages=messages, num_ctx=8192)
                    out = response.choices[0].message.content
                    Path("last-llama3.txt").write_text(out)
                    st.code(out, language="markdown")
                except Exception as e:
                    st.error(f"Error: {str(e)}")

            # second
            with col2:
                st.subheader("gemma 2:2b")
                try:
                    response = completion(model="ollama/gemma2:2b", messages=messages, num_ctx=8192)
                    out = response.choices[0].message.content
                    Path("last-gemma2.txt").write_text(out)
                    st.code(out, language="markdown")
                except Exception as e:
                    st.error(f"Error: {str(e)}")

            st.divider()

            st.write("Exercise for later - install two more models from https://ollama.com/library [including https://ollama.com/library/llama2-chinese!], add two more columns above, put in code to send your prompt to FOUR LLMs and display their responses.")

            st.divider()
        else:
            st.warning("Please enter a prompt.")


# information about the app
st.sidebar.title("About")

st.sidebar.write("This app, derived from https://github.com/Shubhamsaboo/awesome-llm-apps, shows how to invoke (multiple) LLMs via LiteLLM [https://docs.litellm.ai/] - FUN!")

st.sidebar.write(
    "Aim - to create an ER diagram"
)
