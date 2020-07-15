module Darby
  class Portfolio
    include Configurable
    include Quantable
    include ActiveModel::Validations

    REQUIRED_ATTRIBUTES = %i[name type holdings]
    ALLOWED_ATTRIBUTES = REQUIRED_ATTRIBUTES
    CONFIG = :portfolios

    validates_presence_of *REQUIRED_ATTRIBUTES
    attr_accessor *ALLOWED_ATTRIBUTES

    def data_vector(date_range: nil, dataset_size: nil)
      @data_vector ||= begin
        df = Daru::DataFrame.new(stock_hash)

        filter_vector(vector: df.vector_sum, date_range: date_range, dataset_size: dataset_size)
      end
    end

    def stock_hash
      @stock_hash ||= begin
        latest_start_date = stocks.map(&:earliest_date).max.to_date
        earliest_end_date = stocks.map(&:latest_date).min.to_date

        stocks.each_with_object({}) do |stock, acc|
          acc[stock.symbol] = stock.data_vector(date_range: latest_start_date..earliest_end_date)
        end
      end
    end

    def stocks_df
      @stocks_df ||= Daru::DataFrame.new(stock_hash, index: data_vector.index)
    end

    def stocks
      @stocks ||= holdings.map { |stock| Darby::Stock.new(stock) }
    end

    def to_s
      "Portfolio: #{name} - Valid: #{valid?} - Errors: #{errors.messages}"
    end

    # def timeseries_close_data
    #   # TODO: Identify a better format for this
    #   @timeseries_close_data ||= stocks.map { |stock| { stock.symbol => stock.timeseries(adjusted: true, outputsize: "full").adjusted_close.map { |data| [Date.parse(data.first), data.last] } } }
    # end

    def earliest_date
      @earliest_date ||= timeseries_data.map { |timeseries| timeseries.map(&:first).min }
    end

  end
end
