import streamlit as st
import pandas as pd
import plotly.express as px
import seaborn as sns
import matplotlib.pyplot as plt

# PAGE CONFIG
st.set_page_config(
    page_title="Airline Performance Dashboard",
    layout="wide"
)

st.title("Airline Performance Analytics")

# LOAD DATA (PARQUET)
@st.cache_data
def load_airline_kpis():
    return pd.read_parquet("data/parquet/kpi_airline_performance.parquet")


@st.cache_data
def load_route_kpis():
    df = pd.read_parquet("data/parquet/kpi_route_performance.parquet")
    df["route"] = df["origin"] + " → " + df["destination"]
    return df


@st.cache_data
def load_airport_kpis():
    return pd.read_parquet("data/parquet/kpi_airport_performance.parquet")


@st.cache_data
def load_monthly_trends():
    return pd.read_parquet("data/parquet/kpi_monthly_trends.parquet")

# LOAD ALL DATA
df_airline = load_airline_kpis()
df_routes = load_route_kpis()
df_airports = load_airport_kpis()
df_monthly = load_monthly_trends()

# TABS
tab1, tab2, tab3, tab4 = st.tabs(
    ["Airline KPIs", "Route KPIs", "Airport KPIs", "Trends"]
)


# TAB 1 — AIRLINE KPIs
with tab1:
    st.subheader("Airline Performance")

    st.markdown(
        """
        **Flight Volume Threshold**

        Filter airlines based on the minimum number of flights operated.
        This ensures fair comparisons by excluding airlines with very small volumes.
        """
    )

    min_flights = st.slider(
        "Show airlines with at least this many flights",
        min_value=0,
        max_value=int(df_airline["total_flights"].max()),
        value=1_000_000,
        step=500_000,
        format="%d"
    )

    df_airline_f = df_airline[df_airline["total_flights"] >= min_flights]

    
    col1, col2 = st.columns(2)

    with col1:
        fig = px.bar(
            df_airline_f.sort_values("total_flights", ascending=False),
            x="airline_code",
            y="total_flights",
            title="Top Airlines by Total Flights",
            labels={"total_flights": "Total Flights"}
        )
        st.plotly_chart(fig, use_container_width=True)

    with col2:
        fig = px.bar(
            df_airline_f.sort_values("weighted_avg_arr_delay"),
            x="airline_code",
            y="weighted_avg_arr_delay",
            title="Avg Arrival Delay by Airline (Lower is Better)",
            labels={"weighted_avg_arr_delay": "Minutes"}
        )
        st.plotly_chart(fig, use_container_width=True)

    st.dataframe(df_airline_f)


# TAB 2 — ROUTE KPIs
with tab2:
    st.subheader("Route Performance")

    top_routes = (
        df_routes
        .sort_values("total_flights", ascending=False)
        .head(15)
    )

    fig = px.bar(
        top_routes,
        x="total_flights",
        y="route",
        orientation="h",
        title="Top 15 Busiest Airline Routes",
        text="total_flights"
    )
    fig.update_layout(yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig, use_container_width=True)

    st.dataframe(top_routes)


# TAB 3 — AIRPORT KPIs
with tab3:
    st.subheader("Airport Performance")

    col1, col2 = st.columns(2)

    with col1:
        fig = px.bar(
            df_airports.sort_values("total_flights", ascending=False).head(20),
            x="airport",
            y="total_flights",
            title="Busiest Airports (Departures)"
        )
        st.plotly_chart(fig, use_container_width=True)

    with col2:
        fig = px.bar(
            df_airports.sort_values("weighted_avg_arr_delay", ascending=False).head(20),
            x="airport",
            y="weighted_avg_arr_delay",
            title="Worst Airports by Arrival Delay",
            labels={"weighted_avg_arr_delay": "Minutes"}
        )
        st.plotly_chart(fig, use_container_width=True)

    st.dataframe(df_airports)


# TAB 4 — TRENDS
with tab4:
    st.subheader("Monthly Delay Trends")

    airline_selected = st.selectbox(
        "Select Airline",
        sorted(df_airline["airline_code"].unique())
    )

    airline_id = df_airline.loc[
        df_airline["airline_code"] == airline_selected,
        "airline_id"
    ].iloc[0]

    trend_df = df_monthly[df_monthly["airline_id"] == airline_id]

    fig = px.line(
        trend_df,
        x="month",
        y="avg_arr_delay",
        color="year",
        title=f"Monthly Arrival Delay Trend — {airline_selected}"
    )
    st.plotly_chart(fig, use_container_width=True)

# FOOTER
st.markdown("---")
st.markdown(
    """
    SQL • Python • Analytics Engineering

    LinkedIn: https://www.linkedin.com/in/adnanmomin/
    
    GitHub: https://github.com/muhammadadnanmomin
    """
)
