class User < ApplicationRecord
  #username,email,passwordを保存する際のルールを決める
  #usermodelとpostmodelのリレーション
  has_many :posts, dependent: :destroy
  #①ハッシュ化したパスワードを、データベース内の
  #password_digestという属性に保存できるようにする
  #②2つのペアの仮想的な属性が使用できるようになる
  #(password,password_confirmation)
  #③authenticateメソッドが使用できるようになる
  #(引数の文字列がパスワードと一致するとUserオブジェクトを、
  #間違っているとfalseを返す)
  has_secure_password

  before_validation :normalize_email
   
  EMAIL_REGEX = /\A[^\s@]+@[^\s@]+\.[^\s@]+\z/
  #データベースに保存される前に検証
  validates :name, presence: true,length: {maximum: 50 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }, 
                    length: {maximum: 255 },
                    format: { with: EMAIL_REGEX }
                   
  validates :password, presence: true,
                       length: {minimum: 8, maximum: 20 },
                       allow_nil: true


    private

    #to_sは値を文字列に置き換える
    #nilの場合でも空文字に変換
    #strip　文字列の前後にある空白を削除
    #入力ミス防止
    def normalize_email
      self.email = email.to_s.strip.downcase
    end
end
