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
books_info = doc.css("ol#posts")
n = 0
books_info.map do |book|
  n = n
  link = doc.css("li.post a").map {|i| i['href']}[n]
  img = doc.css("li.post img").map {|i| i['src']}[n]
  title = doc.css("a.post_title h1").map {|title| title.text.strip}[n]
  author = doc.css("a.post_title h2").map {|title| title.text.strip}[n]
  description = doc.css("a.post_title p:last-child").map {|title| title.text.strip}[n]

db.execute("INSERT INTO books (title, link, author, description, img) 
            VALUES (?, ?, ?, ?, ?)", title[n], link, author, description, img)
n += 1

end

