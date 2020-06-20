module Darby
  module Quantable

    delegate :default_amount, to: "Global.holdings"

    # including classes need to implement data_vector
    
    # stats_df columns
    # rolling_drawdown_percentage, percent_change, std_dev
    # rolling_10yr_return, rolling_5yr_return, rolling_1yr_return

    def plottable_df
      Daru::DataFrame.new(index: normalized_data_vector.index, adjusted_close: normalized_data_vector)
    end

    # TODO: Handle a freq that sums up data_vector
    def stats_df(date_range: @date_range, dataset_size: @dataset_size)
      Daru::DataFrame.new(
        adjusted_close: data_vector(date_range: date_range, dataset_size: dataset_size),
        percent_change: percent_change,
      )
      # bc rolling blows up if there aren't enough elements
      # rolling returns don't work well bc can't easily identify # of elements = a year
      # @stats_df[:rolling_1yr_return] = rolling_returns(time_range: "1y") if data_vector.size > 365
      # @stats_df[:rolling_5yr_return] = rolling_returns(time_range: "5y") if data_vector.size > 365 * 5
      # @stats_df[:rolling_10yr_return] = rolling_returns(time_range: "10y") if data_vector.size > 365 * 10
      # @stats_df[:rolling_annualized_1yr_return] = rolling_annualized_returns(time_range: "1y") if data_vector.size > 365
      # @stats_df[:rolling_annualized_5yr_return] = rolling_annualized_returns(time_range: "5y") if data_vector.size > 365 * 5
      # @stats_df[:rolling_annualized_10yr_return] = rolling_annualized_returns(time_range: "10y") if data_vector.size > 365 * 10
      @stats_df[:rolling_drawdown_percentage] = rolling_drawdown_percentage if data_vector.size > 13
      @stats_df
    end

    def monthly_data_vector
      @monthly_data_vector ||= begin
        months = data_vector.index.map { |date| "#{date.year}-#{date.month}"}.uniq
        values = months.map { |month| get_last_value(data_vector[month]) }
        Daru::Vector.new(values, index: months)
      end
    end

    def get_last_value(value)
      return value if value.is_a?(Float)

      value.last.first
    end

    def normalized_data_vector(date_range: nil, weight: 1.0)
      normalize_vector(data_vector(date_range: date_range), weight: weight)
    end

    def returns_for_timeframe(timeframe:)
      # needs a to_a bc for some reason datetimeindex doesn't implement last
      end_date = data_vector.index.to_a.last.to_date
      start_date = end_date - timeframe_to_days(timeframe: timeframe)
      returns(start_date: start_date, end_date: end_date)
    end

    def returns(start_date:, end_date:)
      end_date = find_date(date: end_date)
      start_date = find_date(date: start_date)
      (data_vector[end_date.to_s] - data_vector[start_date.to_s]) / data_vector[start_date.to_s]
    end

    def annualized_returns_for_timeframe(timeframe:)
      end_date = data_vector.index.to_a.last.to_date
      start_date = end_date - timeframe_to_days(timeframe: timeframe)
      annualized_returns(start_date: start_date, end_date: end_date)
    end

    def annualized_returns(start_date:, end_date:)
      end_date = find_date(date: end_date)
      start_date = find_date(date: start_date)
      ((1 + returns(start_date: start_date, end_date: end_date)) ** (365 / (end_date - start_date))) - 1
    end

    def find_date(date:)
      if data_vector.index.first > date
        puts "lookback for #{date} is older than oldest date #{data_vector.index.first}. Using oldest date."
        date = data_vector.index.first
      end
      date = date.to_date if date.is_a?(DateTime)
      data_vector[date.to_s].blank? ? find_date(date: date - 1) : date
    end

    def filter_vector(vector:, date_range: nil, dataset_size: nil)
      v = date_range.nil? ? vector : vector[date_range.first.to_s..date_range.last.to_s]
      dataset_size.nil? ? v : v.last(dataset_size)
    end

    def normalize_vector(vector, weight: 1.0)
      stock_count = (default_amount * weight) / vector[0]
      vector * stock_count
    end

    def timeframe_to_days(timeframe:)
      case timeframe
      when /^(\d+)y/i
        365 * $1.to_i
      when /^(\d+)d/i
        $1.to_i
      end
    end

    # def rolling_returns(time_range:)
    #   period = time_range_to_days(time_range: time_range)
    #   data_vector.rolling(:returns, period)
    # end

    # def rolling_annualized_returns(time_range:)
    #   period = time_range_to_days(time_range: time_range)
    #   data_vector.rolling(:annualized_returns, period)
    # end

    def percent_change
      data_vector.percent_change
    end

    def ytd
      @ytd ||= (((percent_change[Date.today.year.to_s].cumsum * default_amount) + default_amount).last / default_amount).data.first
    end

    def volatility
      root_mean_square(rolling_drawdown_percentage.only_valid)
    end

    def rolling_drawdown_percentage
      data_vector.rolling(:drawdown_percentage, 14)
    end

    private

    def root_mean_square(array)
      Math.sqrt(array.reduce(0) { |acc, price| acc += price ** 2 } / array.size)
    end
  end
end
