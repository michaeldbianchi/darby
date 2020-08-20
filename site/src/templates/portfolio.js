import React from "react"
import Highcharts from 'highcharts/highstock'
import HighchartsReact from 'highcharts-react-official'
import { graphql } from 'gatsby'
import Title from "@lekoarts/gatsby-theme-minimal-blog/src/components/title"
import Layout from "@lekoarts/gatsby-theme-minimal-blog/src/components/layout"
export default function Portfolio({ data }) {
  const portfolioData = data.portfoliosJson
  const hypotheticalGrowth = portfolioData.hypotheticalGrowth
  const hypotheticalGrowthOptions = {
    title: {
      text: "10 Year Hypothetical Growth"
    },
    series: hypotheticalGrowth.series
  }
  return (
    <Layout>
      <div>
        <Title text={portfolioData.name} />
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
