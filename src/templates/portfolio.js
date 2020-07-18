import React from "react"
import Highcharts from 'highcharts/highstock'
import HighchartsReact from 'highcharts-react-official'
import { graphql } from 'gatsby'
import Layout from "@lekoarts/gatsby-theme-minimal-blog/src/components/layout"
export default function Portfolio({ data }) {
  const post = data.portfoliosJson
  console.log(post);
  return (
    <Layout>
      <div>Hi from portfolio template</div>
      <div>
        <h1>name: {post.name}</h1>
        {/* <h2>hypotheticalGrowth: {JSON.stringify(post.hypotheticalGrowth.series)}</h2> */}
        <div>
          <HighchartsReact
            highcharts={Highcharts}
            options={post.hypotheticalGrowth}
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
          data {
            x
            y
          }
          name
        }
      }
      name
    }
  }
`
