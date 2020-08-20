import React from "react"
import Highcharts from 'highcharts/highstock'
import HighchartsReact from 'highcharts-react-official'
import { graphql } from 'gatsby'
import Title from "@lekoarts/gatsby-theme-minimal-blog/src/components/title"
import Layout from "@lekoarts/gatsby-theme-minimal-blog/src/components/layout"
export default function stock({ data }) {
  const stockData = data.stocksJson
  const hypotheticalGrowth = stockData.hypotheticalGrowth
  const hypotheticalGrowthOptions = {
    title: {
      text: "10 Year Hypothetical Growth"
    },
    series: hypotheticalGrowth.series
  }
  return (
    <Layout>
      <div>
        <Title text={stockData.name} />
        <h2>Returns</h2>
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
