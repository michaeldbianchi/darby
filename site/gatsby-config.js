require(`dotenv`).config({
  path: `.env`,
})

const shouldAnalyseBundle = process.env.ANALYSE_BUNDLE

module.exports = {
  siteMetadata: {
      // Used for the title template on pages other than the index site
    siteTitle: `Darby`,
    // Default title of the page
    siteTitleAlt: `Darby Financial Analysis`,
    // Will be used to generate absolute URLs for og:image etc.
    siteUrl: `https://finance.michaeldbianchi.com`,
    // Used for SEO
    siteDescription: `Financial Analysis`,
    // Will be set on the <html /> tag
    siteLanguage: `en`,
    // Used for og:image and must be placed inside the `static` folder
    siteImage: `/banner.jpg`,
    // Twitter Handle
    author: `@michaeldbianchi`,
    // Links displayed in the header on the right side
  },
  plugins: [
    {
      resolve: `@lekoarts/gatsby-theme-minimal-blog`,
      // See the theme's README for all available options
      options: {
        externalLinks: [
          // {
          //   name: `Instagram`,
          //   url: `https://www.instagram.com/michaeldbianchi/`,
          // },
          {
            name: `GitHub`,
            url: `https://github.com/michaeldbianchi/darby`,
          }
        ],
        // Navigation links
        navigation: [
          {
            title: `Blog`,
            slug: `/blog`,
          },
          {
            title: `About`,
            slug: `/about`,
          },
          {
            title: `Finance`,
            slug: `/finance`
          },
        ],    
        formatString: `YYYY-MM-DD`,
        mdx: false,
      },
    },
    `gatsby-transformer-json`,
    {
      resolve: "gatsby-plugin-page-creator",
      options: {
        path: `${__dirname}/content/finance`,
      },
    },
    {
      resolve: `gatsby-plugin-mdx`,
      options: {
        defaultLayouts: {
          finance: require.resolve("./src/components/layout.tsx")
        }
      }
    },
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        name: `finance`,
        path: `${__dirname}/content/finance`,
      },
    },
    {
      resolve: `gatsby-plugin-google-analytics`,
      options: {
        trackingId: process.env.GOOGLE_ANALYTICS_ID,
      },
    },
    `gatsby-plugin-sitemap`,
    {
      resolve: `gatsby-plugin-manifest`,
      options: {
        name: `minimal-blog - @lekoarts/gatsby-theme-minimal-blog`,
        short_name: `minimal-blog`,
        description: `Typography driven, feature-rich blogging theme with minimal aesthetics. Includes tags/categories support and extensive features for code blocks such as live preview, line numbers, and code highlighting.`,
        start_url: `/`,
        background_color: `#fff`,
        theme_color: `#6B46C1`,
        display: `standalone`,
        icons: [
          {
            src: `/android-chrome-192x192.png`,
            sizes: `192x192`,
            type: `image/png`,
          },
          {
            src: `/android-chrome-512x512.png`,
            sizes: `512x512`,
            type: `image/png`,
          },
        ],
      },
    },
    `gatsby-plugin-offline`,
    `gatsby-plugin-netlify`,
    shouldAnalyseBundle && {
      resolve: `gatsby-plugin-webpack-bundle-analyser-v2`,
      options: {
        analyzerMode: `static`,
        reportFilename: `_bundle.html`,
        openAnalyzer: false,
      },
    },
  ].filter(Boolean),
}
