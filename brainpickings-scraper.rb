require 'nokogiri'
require 'open-uri'
require 'sqlite3'
require 'FileUtils'

FileUtils.rm("books.db") if File.exists?("books.db")

db = SQLite3::Database.new "books.db"

db.execute <<-SQL
  CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT,
    link TEXT,
    author TEXT,
    description TEXT,
    img TEXT
  );
SQL

books_url = "http://bookpickings.brainpickings.org/"
doc = Nokogiri::HTML(open(books_url))
books_links = doc.css("ol#posts li.post a")
# .map {|i| i['href']}

books_links.map do |book_link|
  link = book_link['href']
  doc2 = Nokogiri::HTML(open(link))
    # link = doc.css("li.post a").map {|i| i['href']}
    # img = doc.css("li.post img").map {|i| i['src']}
    puts title = doc.css("ol#posts li.post h1").map {|title| title.text.strip}
    # author = doc.css("a.post_title h2").map {|title| title.text.strip}
    # description = doc.css("a.post_title p:last-child").map {|title| title.text.strip}

    # db.execute("INSERT INTO books (title, link, author, description, img) 
    #             VALUES (?, ?, ?, ?, ?)", title, link, author, description, img)

end

