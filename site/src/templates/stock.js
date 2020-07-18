import React from "react"
import Highcharts from 'highcharts/highstock'
import HighchartsReact from 'highcharts-react-official'
import { graphql } from 'gatsby'
import Layout from "@lekoarts/gatsby-theme-minimal-blog/src/components/layout"
export default function Stock({ data }) {
  const stockData = data.stocksJson
  const hypotheticalGrowth = stockData.hypotheticalGrowth
  const hypotheticalGrowthOptions = {
    title: {
      text: stockData.name
    },
    series: hypotheticalGrowth.series
  }
  return (
    <Layout>
      <div>Hi from stock template</div>
      <div>
        <h1>name: {stockData.name}</h1>
        <div>
          <HighchartsReact
            highcharts={Highcharts}
            options={hypotheticalGrowthOptions}
            constructorType = { 'stockChart' }
          />
        </div>
      </div>
    </Layout>
  )
}

export const query = graphql`
  query($slug: String!) {
    stocksJson(fields: { slug: { eq: $slug } }) {
      hypotheticalGrowth {
        series {
          data
          name
        }
      }
      name
    }
  }
`
