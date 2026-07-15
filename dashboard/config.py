import streamlit as st


def page_config(title: str, icon: str):
    """
    Configure every dashboard page.
    """

    st.set_page_config(
        page_title=title,
        page_icon=icon,
        layout="wide",
        initial_sidebar_state="expanded"
    )