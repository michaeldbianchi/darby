import React from "react"
import { graphql } from 'gatsby'
import Layout from "@lekoarts/gatsby-theme-minimal-blog/src/components/layout"
export default function Portfolio({ data }) {
  const post = data.portfoliosJson
  console.log(post);
  return (
    <Layout>
      <div>Hi from portfolio template</div>
      <div>
        <h1>Symbol: {post.symbol}</h1>
        <h2>AdjustedClose: {post.adjustedClose}</h2>
      </div>
    </Layout>
  )
}

export const query = graphql`
  query($slug: String!) {
    portfoliosJson(fields: { slug: { eq: $slug } }) {
      adjustedClose
      symbol
    }
  }
`
