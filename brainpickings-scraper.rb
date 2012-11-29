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
books_info = doc.css("ol#posts li")

books_info.each do |book_li|
  # now to find the elements in each individual book_li
  link = book_li.css("a").attribute("href") #is that the nokogiri HTML element attribute method?
  img = book_li.css("img").attribute("src")
  title = book_li.css("h1").text.strip
  author = book_li.css("h2").text.strip
  description = book_li.css("a.post_title p:last-child")..text.strip}

  db.execute("INSERT INTO books (title, link, author, description, img) 
            VALUES (?, ?, ?, ?, ?)", title[n], link, author, description, img)

end

