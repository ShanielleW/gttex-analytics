defmodule GttexAnalyticsWeb.Tlogs do
  use GttexAnalyticsWeb, :model

  schema "tlogs" do
    field :agency_id, :integer
    field :log_type, :integer
    field :obj, :integer
    field :obj_id, :integer
    field :amount, :integer
    field :currency, :integer
    field :tlog_referer, :integer
    field :tlog_request, :string
    field :tlog_keyword, :integer
    field :tlog_visitor, :integer
    field :ip, :string
    field :status, :integer
    field :ts, :naive_datetime
    field :geoname_id, :integer
  end

  def tlogs_get() do
    sql =
      "select tlogs.*,
      tlog_referers.name as referer,
      tlog_requests.name as request,
      tlog_visitors.cookie_id as visitor_id,
      tlog_visitors.browser as ua
      FROM tlogs
      left outer join tlog_referers on (tlogs.tlog_referer_id = tlog_referers.id)
      left outer join tlog_requests on (tlogs.tlog_request_id = tlog_requests.id)
      left outer join tlog_visitors on (tlogs.tlog_visitor_id = tlog_visitors.id)
      order by tlogs.id desc;"
      case GttexAnalyticsWeb.Repo.query(sql) do
        {:ok, data} ->
          data
        {:error, data} ->
          []
      end
    end
    def kafka_message_send(message, key\\ nil)do
      message = %KafkaEx.Protocol.Produce.Message{key: key, value: message}
      request = %KafkaEx.Protocol.Produce.Request{
        topic: "topic",
        partition: 0,
        required_acks: 1,
        messages: [message]
      }
      KafkaEx.produce(request)
    end
    def process_batch() do
      GttexAnalytics.Stream
      |> where([s], is_nil(s.processed))
      |> GttexAnalytics.Repo.all
      |> Enum.each(fn(stream) -> process(stream) end)
    end

    def process(%GttexAnalytics.Stream{type: 'tlogs'} = stream) do
      Poison.encode!({
      agencyid => :agency_id,
      log => :log_type,
      obj => :obj,
      obj_id => :obj_id,
      amount => :amount,
      curr => :currency,
      referer => :tlog_referer,
      request => :tlog_request,
      keyword => :tlog_keyword,
      visitors => :tlog_visitor,
      ip => :ip,
      status => :status,
      ts => :ts,
      geoname => :geoname});
    end
    #defp geo(a, stream) do
    #  if location = Geolix.lookup(stream.package["ip"]) do
    #    cond do
    #      Map.has_key?(loc, :city) && location.city.geoname_id)->
    #        Map.put(a, :geoname_id, location.city.geoname_id)
    #    end
    #  end
    #end



    def kafka_message_get(stream, key\\ nil)do
      KafkaEx.fetch("key", 0, offset: 0)
    end
end
