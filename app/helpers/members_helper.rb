module MembersHelper
    # スケジュール表の生成に必要なデータを準備するヘルパー
    # Viewでのロジックを最小限にするため、ここでデータの加工を行う
    def schedule_data(member)
        days = %w(月 火 水 木 金 土 日)

        # N+1対策: メンバーの空き時間をセットに格納して高速検索
        # "曜日:時間" の形式の文字列をセットに保持する
        free_schedule_set = member.free_dates.map { |fd| "#{fd.day}:#{fd.free_hour.hour}" }.to_set

        {
            days: days,
            hours: (0..23).to_a,
            checked_schedules: free_schedule_set
        }
    end
end
