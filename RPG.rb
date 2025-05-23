# 定数クラス
class Constants
  # こうげきタイプ
  ATTACK_TYPE_NORMAL = 1 # 通常攻撃
  ATTACK_TYPE_MAGIC = 2  # 魔法攻撃
  ATTACK_CRITICAL = 5 # クリティカル攻撃
  ATTACK_MINUS_CRITICAL = 3 # マイナスクリティカル
  HP_MIN = 0 # HPがマイナスにならないように最小値を0と定義する
  ACTION_ATTACK = 1 # 攻撃
  ACTION_ESCAPE = 2 # 逃げる
end

# 2. キャラクタークラス
class Character
    attr_accessor :name, :hp, :attack_damage, :attack_type, :is_player, :is_alive # ステイタス

    def initialize(name, hp, attack_damage, attack_type, is_player = false)
        @name = name                    # キャラクター名
        @hp = hp                        # HP
        @attack_damage = attack_damage  # こうげき力
        @attack_type = attack_type      # こうげきタイプ
        @is_player = is_player          # プレイヤーフラグ
        @is_alive = true                # 生存フラグ
        @escape_flag = false            # 逃げるフラグ
    end

    def calculate_damage # (こうげきのダメージを計算するメソッド)
        @attack_damage # キャラクターの攻撃力を基にする
        rand(@attack_damage - Constants::ATTACK_MINUS_CRITICAL..@attack_damage + Constants::ATTACK_CRITICAL)
    end

    def receive_damage(damage)   # (ダメージを実際に反映するメソッド)
        @hp -= damage # hpがキャラくだーのダメージによって減少する
        
        # 戦闘不能になったとき
        if @hp <= Constants::HP_MIN
            @hp = Constants::HP_MIN
            @is_alive = false
        end
    end
end

# 1.ゲーム進行クラス
class Game 
    def initialize # 初期設定
        hero_name = ""
        @round = 0
        loop do # yes no　の選択でループ
            puts "↓勇者の名前を入力してください↓"
            hero_name = gets.chomp # 名前の入力
            puts "勇者の名前は#{hero_name}でいいのか？ (yes / no)"

            answer = gets.chomp.downcase
            if answer == "yes"
                puts "勇者の名前は#{hero_name}です"
                break
            elsif answer == "no"
                puts "もう一度入力してください"
            else
                puts "yesかnoで答えてください"
            end
        end

        # キャラクター生成
        @heroes = create_heroes(hero_name)
        @monsters = create_monsters

        # キャラクターの情報
        @heroes.each { |hero| display_character_info(hero) }
        @monsters.each { |monster| display_character_info(monster) }
    end

    def start # ゲーム進行
        @escape_flag = false
        puts "\n◆◆◆ モンスターが現れた！ ◆◆◆" # 開始メッセージ
        display_status()        # 最新ステータス
        process_heroes_turn()   # 勇者パーティーのターン
        return if @escape_flag  # 逃げられた場合ループを抜ける
        process_monsters_turn() # モンスターパーティーのターン
    end

    private
    # 勇者パーティーを作成
    def create_heroes(hero_name)
        [
            Character.new(hero_name, 30, 9, Constants::ATTACK_TYPE_NORMAL, true),
            Character.new("魔法使い", 26, 10, Constants::ATTACK_TYPE_MAGIC, true),
            Character.new("遊び人", 30, 9, Constants::ATTACK_TYPE_NORMAL, true),
            Character.new("ニート", 5, 2, Constants::ATTACK_TYPE_NORMAL, true)
        ]

    end
    # モンスターを作成
    def create_monsters
        [
            Character.new("オーク", 50, 9, Constants::ATTACK_TYPE_NORMAL, true),
            Character.new("オークキング", 150, 9, Constants::ATTACK_TYPE_NORMAL, true)
        ]
    end

    def display_character_info(character)
        puts "\nキャラクター名: #{character.name}"
        puts "HP: #{character.hp}" # 30
        puts "攻撃力: #{character.attack_damage}" # 9
        puts "攻撃タイプ: #{character.attack_type}" # 1 
        puts "プレイヤーフラグ: #{character.is_player}" # false
        puts "生存フラグ: #{character.is_alive}" # true
    end

    # キャラクターのステータス
    def display_status
        puts "\n▼ 勇者パーティー"
        @heroes.each do |hero|
            puts "・【#{hero.name}】 HP：#{hero.hp} こうげき力：#{hero.attack_damage}"
        end

        puts "\n▼ モンスターパーティー"
        @monsters.each do |monster|
            puts "・【#{monster.name}】 HP：#{monster.hp} こうげき力：#{monster.attack_damage}"
        end
    end
    def execute_attack(attacker, defender) # (攻撃するキャラクター, 攻撃対象)
        # 攻撃メッセージ
        case attacker.attack_type
        when Constants::ATTACK_TYPE_NORMAL
            puts "#{attacker.name}の攻撃！！！"
        when Constants::ATTACK_TYPE_MAGIC
            puts "#{attacker.name}の魔法攻撃！！！"
        end
    
        # ダメージ処理
        damage = attacker.calculate_damage() # ダメージ計算
        defender.receive_damage(damage)      # ダメージ反映

        puts "#{defender.name} に #{damage}のダメージ!" # ダメージ処理
        puts "#{@defender.name}は気絶した" unless defender.is_alive # 戦闘不能メッセージ
    end
    def execute_escape(character)
        if rand < 0.7
            puts "#{character.name}は逃げ出した！"
            @escape_flag = true # 逃げるフラグを立てる
        else
            puts "#{character.name}敵に回り込まれた！"
            @escape_flag = false
        end
    end

    # 勇者のターン
    def process_heroes_turn
        loop do
            @round += 1
            puts "\n=== ラウンド #{@round} ==="

            # ステータス表示
            display_status()    # 勇者とモンスターの表示

            puts "\n↓ 行動を選択してください"
            puts "【#{Constants::ACTION_ATTACK}】 攻撃"
            puts "【#{Constants::ACTION_ESCAPE}】 逃げる"
            choice = gets.to_i # 行動の入力を整数で受け付ける

            # 行動
            case choice 
            when Constants::ACTION_ATTACK # 攻撃
                execute_attack(@heroes, @monsters)
                break
            when Constants::ACTION_ESCAPE # 逃げる
                execute_escape(@heroes)
                return
            else
                # 1 2 以外のコマンド ※、文字列を受け取った場合は0として変換されてしまうことに注意が必要です。
                puts "無効な選択です"
            end

            hero_status()
            return if @escape_flag # 逃げた場合終了

            process_monsters_turn() # モンスターのターン
        end
    end

    # モンスターのターン
    def process_monsters_turn
        if @monsters.is_alive
            execute_attack(@monsters, @heroes) # (攻撃するキャラクター, 攻撃される対象)
        end
    end
end


game = Game.new
game.start()
