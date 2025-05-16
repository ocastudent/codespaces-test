# 1.ゲーム進行クラス
class Game 
    def initialize # 初期設定
        hero_name = ""
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
        display_character_info(@heroes)
        display_character_info(@monsters)
    end
    private

    # 勇者パーティーを作成
    def create_heroes(hero_name)
        Character.new(hero_name, 30, 9, Constants::ATTACK_TYPE_NORMAL, true) 
    end

    # モンスターを作成
    def create_monsters
        Character.new("オーク", 50, 9, Constants::ATTACK_TYPE_NORMAL, true) 
    end

    def display_character_info(character)
        puts "\nキャラクター名: #{character.name}"
        puts "HP: #{character.hp}" # 30
        puts "攻撃力: #{character.attack_damage}" # 9
        puts "攻撃タイプ: #{character.attack_type}" # 1 
        puts "プレイヤーフラグ: #{character.is_player}" # false
        puts "生存フラグ: #{character.is_alive}" # true
    end
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
    end
end

# 定数クラス
class Constants
  # こうげきタイプ
  ATTACK_TYPE_NORMAL = 1 # 通常攻撃
  ATTACK_TYPE_MAGIC = 2  # 魔法攻撃
end




Game.new
