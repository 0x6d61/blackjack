class BlackJack
  BJ_MAX_NUM = 21
  def initialize
    @card = ["A","1","2","3","4","5","6","7","8","9","K","Q","J"].inject([]){ |acc, n| acc << (n * 4).split("") }.flatten
    @card.sort!{ |a, b| rand(6) <=> rand(6) }
    @player = Array.new
    @dealer = Array.new
  end

  def card_to_integer(card)
    sum = 0
    picturecard_to_ten = card.map { |cd| "KQJ".include?(cd) ? "10" : cd }.sort { |a, b| a.ord <=> b.ord }
    c = picturecard_to_ten.map do |i|
      if "A" == i
        #11,1どちらかプレイヤーに良い手から選ぶ
        eleven = BJ_MAX_NUM - (sum + 11) >= 0 ? BJ_MAX_NUM - (sum + 11) : 100
        one = BJ_MAX_NUM - (sum + 1) >= 0 ? BJ_MAX_NUM - (sum + 1) : 100
        if eleven > one
          sum += 1
          1
        else
          sum += 11
          11
        end
      else
        sum += i.to_i
        i.to_i
      end
    end
    c
  end

  def hit
    @card.shift
  end

  def stay
    puts "\n勝負！！\n\n"
    loop do
      dealer_hand = self.card_to_integer(@dealer)
      if dealer_hand.sum > BJ_MAX_NUM
        self.print_hand
        puts "\nplayerの勝ちです。\n\n"
        return
      elsif BJ_MAX_NUM >= dealer_hand.sum && dealer_hand.sum >= 17
        break
      end
      @dealer << self.hit
    end
    player_hand = self.card_to_integer(@player)
    dealer_hand = self.card_to_integer(@dealer)
    player_point = BJ_MAX_NUM - player_hand.sum
    dealer_point = BJ_MAX_NUM - dealer_hand.sum
    self.print_hand
    if dealer_point > player_point
      puts "\nplayerの勝ちです。\n\n"
    elsif dealer_point == player_point
      puts "\n引き分けです。\n\n"
    else
      puts "\ndealerの勝ちです。\n\n"
    end
    return
  end

  def game
    @player += [self.hit, self.hit]
    @dealer += [self.hit, self.hit]
    loop do
      puts "player: #{@player}"
      puts "dealer:#{[@dealer[0], "*"]}"
      puts "hitかstayを入力してください。"
      order = gets.chomp
      case order
      when "hit"
        @player << self.hit
        hand = self.card_to_integer(@player).sum
        if hand > BJ_MAX_NUM
          puts "player: #{@player}"
          puts "dealer:#{[@dealer[0], "*"]}"
          puts "\ndealerの勝ちです。\n\n"
          break
        end
      when "stay"
        self.print_hand
        self.stay
        break
      else
        puts "hitかstayを入力してください。"
      end
    end
    puts "\nゲームを続けますか？(Yes/No)"
    continue = gets.chomp
    if continue.upcase == "NO"
        exit
    end
  end

  def print_hand
    puts "player: #{@player}"
    puts "dealer:#{@dealer}"
  end
end

loop {
  puts "\nゲームスタート\n\n"
  puts "=" * 12
  bk = BlackJack.new
  bk.game
}
