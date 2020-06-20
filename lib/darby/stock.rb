module Darby
  class Stock
    include Configurable
    include Quantable
    include ActiveModel::Validations

    REQUIRED_ATTRIBUTES = %i[name type symbol]
    ALLOWED_ATTRIBUTES = REQUIRED_ATTRIBUTES + %i[date_range dataset_size]
    CONFIG = :stocks

    validates_presence_of *REQUIRED_ATTRIBUTES
    attr_accessor *ALLOWED_ATTRIBUTES

    def data_vector(date_range: nil, dataset_size: nil)
      filter_vector(vector: adjusted_close_vector, date_range: date_range, dataset_size: dataset_size)
    end

    def stock
      @stock ||= AlphaVantage.client.stock(symbol: symbol)
    end

    def timeseries
      @timeseries ||= stock.timeseries(adjusted: true, outputsize: "full")
    end

    def adjusted_close
      @adjusted_close ||= timeseries.adjusted_close.reverse.map { |pair| Float(pair.last)}
    end

    def close
      @close ||= timeseries.close.map { |pair| Float(pair.last)}
    end

    def earliest_date
      # bc evidently date_index.min does something very strange
      # TODO: file issue
      date_index.minmax.first
      # can just use min while using an arrays of dates
      # date_index.min
    end

    def transform_dates(data_array)
      data_array.map { |entry| [Date.parse(entry.first), entry.last] }
    end

    def date_index
      # makes an assumption on adjusted close having full data
      # DateTimeIndex is kind of a pain - really just looking for a date index
      @date_index ||= Daru::DateTimeIndex.new(timeseries.adjusted_close.reverse.map(&:first))
      # @date_index ||= timeseries.adjusted_close.map(&:first)
    end

    def adjusted_close_vector
      @adjusted_close_vector ||= Daru::Vector.new(adjusted_close, index: date_index)
    end

    def adjusted_close_df
      @adjusted_close_df ||= Daru::DataFrame.new({adjusted_close: adjusted_close}, index: date_index)
    end

    def close_vector
      @close_vector ||= Daru::Vector.new(close, index: date_index)
    end

    def adjusted_close_df
      @adjusted_close_df ||= Daru::DataFrame.new({adjusted_close: adjusted_close}, index: date_index)
    end
  end
end