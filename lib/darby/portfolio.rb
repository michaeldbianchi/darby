module Darby
  class Portfolio
    include Configurable
    include ActiveModel::Validations

    REQUIRED_ATTRIBUTES = %i[name type holdings]
    ALLOWED_ATTRIBUTES = REQUIRED_ATTRIBUTES
    CONFIG = :portfolios

    validates_presence_of *REQUIRED_ATTRIBUTES
    attr_accessor *ALLOWED_ATTRIBUTES

    def stocks
      @stocks ||= holdings.map { |stock| AlphaVantage.client.stock(symbol: stock[:symbol])}
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
