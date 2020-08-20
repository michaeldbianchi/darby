/** @jsx jsx */
import React from "react"
import { jsx, Link as TLink } from "theme-ui"
import { Box } from "@theme-ui/components"
import { Link } from "gatsby"

import { PieChart, PieArcSeries } from 'reaviz';

type Holding = {
  key: string
  data: number
}

type PortfolioListItemProps = {
  portfolio: {
    fields: {
      slug: string
    }
    name: string
    holdings: Holding[]
    description?: string
  }
}



const PortfolioListItem = ({ portfolio }: PortfolioListItemProps) => (
  <Box mb={4} sx={{ 
    // boxShadow: "0 0 8px rgba(0,0,0,0.125)"
    boxShadow: `rgba(0, 0, 0, 0.2) 0px 8px 16px`,
    borderRadius: `12px`,
    p: "12px"
  }}>
      <TLink as={Link} to={portfolio.fields.slug} sx={{ fontSize: [1, 2, 3], color: `text`, mt: `100px` }}>
        {portfolio.name}
      </TLink>
      <PieChart
        height={350}
        width={350}
        data={portfolio.holdings}
        series={<PieArcSeries doughnut={true} />}
      />

  </Box>
)

export default PortfolioListItem