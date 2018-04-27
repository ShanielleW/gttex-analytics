defmodule GttexAnalyticsWeb.Analytics do
  use GttexAnalyticsWeb , :model
  schema "analytics" do
    field :token, :string
    field :agency_id, :integer
    field :user_id, :integer
    field :action, :string
    field :action_id, :integer
    field :utm_source, :string
      field :utm_medium, :string
      field :utm_campaign, :string
      field :utm_term, :string
      field :utm_content, :string
    field :ip, :string
    field :device, :string
  end

  def analytics_get() do
    sql =
      "select actions.*,
      visitors.device as device
      FROM actions
      left outer join visitors on (actions.token = visitors.token)
      order by actions.id desc;"
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
    def kafka_message_get(message, key\\ nil)do
      KafkaEx.fetch("key", 0, offset: 0)
    end

  end
