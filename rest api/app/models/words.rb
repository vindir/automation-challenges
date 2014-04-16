require 'sqlite3'

class Words
  @@db = SQLite3::Database.open './db/words.db'

  def self.db
    @@db
  end

  def self.add_word(word)
    begin
      count = count_for(word) + 1

      if count > 1
        db.execute "UPDATE Words SET Count=#{count} WHERE Wordname='#{word}'"
      else
        db.execute "INSERT INTO Words VALUES('#{word}', #{count})"
      end
    end
    count
  end

  def self.delete_word(word)
    db.execute "DELETE FROM Words WHERE Wordname='#{word}'"
  end

  def self.count_for(word)
    begin
      count = db.get_first_value "SELECT Count FROM Words WHERE Wordname='#{word}'"
    end
    count || 0
  end

  def self.all_words
    results = db.execute "SELECT * FROM Words"
    Hash[results.map {|entry| [entry[0], entry[1]]}]
  end

  def self.delete_all_words
    results = db.execute "DELETE FROM Words"
  end
end
