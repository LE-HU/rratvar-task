# frozen_string_literal: true
<<~DESC
heredoc test
DESC
################################################################################
# 1.

input_string = 'Ala ma kotozaura wiec jest bardzo okejson'

module Example
  def self.percent(total, value)
    rounded_percentage = (100 * value / total.to_f).round(2)
    "#{rounded_percentage}%"
  end

  def self.reverse_long_words(string)
    string.split(/\W/)
          .each { |word| word.reverse! if word.size > 5 }
          .join(' ')
          .squeeze(' ') # squeeze to trim whitespaces left from .,;'"?! chars.
  end

  def self.split_number(number)
    equation_array = []
    splitted_digits_reversed = number.to_s.reverse.split('').map(&:to_i)

    splitted_digits_reversed.each_with_index do |digit, index|
      equation_array << (digit * 10**index).to_s if digit != 0
    end

    formatted_output = equation_array.reverse.join(' + ')
    "#{number} = #{formatted_output}"
  end

  def self.alphabet_position(text)
    position_list = []

    text.downcase.split('').each do |char|
      position_list << char.ord - 96 if char =~ /[a-z]/
    end

    position_list.join(' ')
  end
end

# print results
puts '***' * 10
puts '1.'
puts '***'
puts Example.percent(53, 20)
puts '***'
puts Example.reverse_long_words(input_string)
puts '***'
puts Example.split_number(12_350)
puts '***'
puts Example.alphabet_position(input_string)
puts '***' * 10

################################################################################
# 2.

# class Patient
<<~DESC
a) invalid keyword arguments, albo musimy przenieść optional argument na
początek, albo najlepiej  zmienić każdy z argumentów na typ keyword.
DESC
#   def initialize(id:, first_name = nil, last_name: nil)
#   @id = id
<<~DESC
b) niespójność camelCase vs. snake_case.
DESC
#   @firstName = first_name
#   @last_name = last_name
#   end
<<~DESC
c) class method nie może porównywać argumentu id z instance parameter
 @id, również logika wydaje się odwrócona.
DESC
#   def self.patient?(id)
#   id != @id
#   end
<<~DESC
d) w obecnym kształcie metoda zakłada istnienie attr_reader. Metoda powinna
korzystać z instance variables @firstName, @last_name lub klasa powinna mieć
zdefinowane attr_reader dla wyżej wspomnianych. W przypadku zdefiniowania
argumentów wejściowych jako default: nil, metoda '+' zwraca NoMethodError.
DESC
#   def full_name
#   firstName + last_name
#   end
#   end
<<~DESC
e) Niekompletna lista argumentów, zadziała tylko w przypadku przypisania default
wartości dla pozostałych arg.
DESC
#   patient_1 = Patient.new(id: "123")
<<~DESC
f) W obecnym kształcie, class method wywoływane jest poniżej na instancji klasy.
DESC
#   patient_1.patient?("123")
<<~DESC
g) W obecnym kształcie, full_name wywołane jest bez prawidłowej definicji
first_name i last_name, w przypadku wartości nil zwróci NoMethodError.
DESC
#   patient_1.full_name
<<~DESC
h) Poniższe wywołanie zakłada istnieje first_name i last_name na pierwszej i
drugiej pozycji parametrów metody. Ignoruje to obecność ID - error.
DESC
#   patient_2 = Patient.new("Karol", "Tychek")
<<~DESC
i) w dalszej części powtarzają się te same błędy.
DESC
#   patient_2.patient?("123")
#   patient_2.full_name
#   patient_3 = Patient.new(id: "123", "Roman")
#   patient_3.patient?("Roman")
#   patient_3.full_name
puts '***' * 10

# Ad 2. Prawidłowa proponowana implementacja.
class Patient
  def initialize(id:, first_name: nil, last_name: nil)
    @id = id
    @first_name = first_name
    @last_name = last_name
  end

  def patient?(patient_id)
    @id == patient_id
  end

  def full_name
    # w przypadku wartości nil zwróci string ze spacją w miejsce nil'a"
    "#{first_name} #{last_name}"
  end

  private

  attr_reader :id, :first_name, :last_name
end

# print results
pp patient1 = Patient.new(id: 1, first_name: 'Lorem', last_name: 'Ipsum')
pp patient1.patient?(1)
pp patient1.patient?(5)
pp patient1.full_name

pp patient2 = Patient.new(id: 'abc',first_name: 123)
pp patient2.patient?(1)
pp patient2.patient?('abc')
pp patient2.full_name
puts '***' * 10

################################################################################
# 3.

# # Post(id: :integer, title: :string, body: :text, published_at: :datetime)
# class Post < ApplicationRecord
#   has_many :comments
#   end
#   # Comment(id: :integer, body: :string, author_id: :integer, removed: :boolean)
#   class Comment < ApplicationRecord
#   belongs_to :post
#   belongs_to :author
#   end
#   # Author(id: :integer, first_name: :string, last_name: :string)
#   class Author < ApplicationRecord
#   has_many :comments
#   end
#   # W aplikacji zostały zdefiniowane następujące modele
#   # Napisz serwis, który:
#   # 1. Przyjmie w paramterach numer strony i limit na stronę
#   # 2. Ograniczy maksymalny limit do 100
#   # 3. Wyciągnie tylko opublikowane posty i posortuje je malejąco po dacie publikacji
#   # 4. Zwróci hash o podanej strukturze:
#   # - id, tytuł i treść posta,
#   # - kolekcje komentarzy: id, body i imię i naziwsko autora ( bez komentarzy oznaczonych jako usuniete )
<<~SERWIS
class GetPaginatedPostsService
  def initialize(post_model: Post, page:, limit:)
    @post_model = post_model
    @page = page
    limit > 100 ? @limit = 100 : @limit = limit
  end

  def call
    posts_hash
  end

  private

  attr_reader :post_model, :page, :limit

  def posts_hash
    posts.map do |post|
      {
        id: post.id,
        title: post.title,
        body: post.body,
        comments: comments_hash(post)
      }
    end
  end

  def comments_hash(given_post)
    given_post.comments.each do |comment|
      {
        id: comment.id,
        body: comment.body,
        name: comment.author&.first_name
      }
    end
  end

  def posts
    post_model.where.not(published_at: nil)
              .order(published_at: :DESC)
              .offset(page * limit)
              .limit(limit)
  end
end
SERWIS
# Nie wiem natomiast czy w tym zadaniu chodzi o działającą apke renderującą
# JSON'a z tą odpowiedzą, czy o samo query jak w przykładzie powyżej.
# Z tego powodu stworzyłem web app z osobnym route renderującym odp. serwisu.
# Działający route /serwis można sprawdzić w aplikacji po zaseedowaniu db.
# Odpowiedzią jest JSON o zadanej strukturze.
