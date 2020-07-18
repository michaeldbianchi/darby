import React from "react"
import Highcharts from 'highcharts/highstock'
import HighchartsReact from 'highcharts-react-official'
import { graphql } from 'gatsby'
import Layout from "@lekoarts/gatsby-theme-minimal-blog/src/components/layout"
export default function Portfolio({ data }) {
  const portfolioData = data.portfoliosJson
  const options = {
    title: {
      text: portfolioData.name
    },
    series: portfolioData.hypotheticalGrowth.series
  
  }
  return (
    <Layout>
      <div>Hi from portfolio template</div>
      <div>
        <h1>name: {portfolioData.name}</h1>
        <div>
          <HighchartsReact
            highcharts={Highcharts}
            options={portfolioData.hypotheticalGrowth}
            constructorType = { 'StockChart' }
          />
        </div>
      </div>
    </Layout>
  )
}

export const query = graphql`
  query($slug: String!) {
    portfoliosJson(fields: { slug: { eq: $slug } }) {
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
