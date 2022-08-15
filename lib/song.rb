class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end

  def self.create_table
    # v hold reference to creating table
          # v indicate that the code here is SQL
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
      SQL
    # ^end of SQL code

    DB[:conn].execute(sql)
              # ^ Do stuff labeled sql 
        # ^connect to database
  # ^ name of database connection in environment file
  end

  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.album)
    # do stuff labeled sql with ^these values^ instead of ?

    # get the song ID from the database and save it to the Ruby instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # return the Ruby instance
    self
  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

end
