/** @jsx jsx */
import React from "react"
import { jsx, Link as TLink } from "theme-ui"
import { Box } from "@theme-ui/components"
import { Link } from "gatsby"
import ItemTags from "@lekoarts/gatsby-theme-minimal-blog/src/components/item-tags"

type PortfolioListItemProps = {
  portfolio: {
    fields: {
      slug: string
    }
    name: string
    description?: string
  }
}

const PortfolioListItem = ({ portfolio }: PortfolioListItemProps) => (
  <Box mb={4}>
    <TLink as={Link} to={portfolio.fields.slug} sx={{ fontSize: [1, 2, 3], color: `text` }}>
      {portfolio.name}
    </TLink>
    {/* <p sx={{ color: `secondary`, mt: 1, a: { color: `secondary` }, fontSize: [1, 1, 2] }}>
      <time>{portfolio.date}</time>
      {portfolio.tags && showTags && (
        <React.Fragment>
          {` — `}
          <ItemTags tags={portfolio.tags} />
        </React.Fragment>
      )}
    </p> */}
  </Box>
)

export default PortfolioListItem