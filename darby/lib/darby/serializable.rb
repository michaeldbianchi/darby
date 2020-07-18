module Darby
  module Serializable
    def serialize
      {
        name: name,
        hypotheticalGrowth: df_to_highchart_hash(normalized_df(date_range: timeframe_to_date_range(timeframe: '10y'))),
        dailyTimeseries: nil,
        annualizedReturns: nil,
        totalReturns: nil,
      }
    end

    def df_to_highchart_hash(df)
      {
        title: {
          text: df.name
        },
        series: series(df)
      }
    end

    def series(df)
      df.vectors.map do |vec_name|
        {
          data: series_data(df[vec_name]),
          name: vec_name,
          tooltip: {
                valueDecimals: 2
            }
        }
      end
    end

    def series_data(vector)
      vector.index.map(&:to_date).zip(vector).map do |date, value|
        [date_to_ms_timestamp(date), value]
      end
    end

    def date_to_ms_timestamp(date)
      date.to_time.to_i * 1000
    end
  end
end
