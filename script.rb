require 'imgkit'
require "koala"
require "pry"
require 'rest_client'
require "erb"
require "json"
require "yaml"

#May need to run this
# gem install wkhtmltoimage-binary


config = YAML.load_file('config.yaml')
@@FACEBOOK_TOKEN = config["FACEBOOK_TOKEN"]

@@url = config["URL"]

@@FACEBOOK_GRAPH_POST_PHOTO_URL = config["FACEBOOK_URL"]

@file_name = ""
@title = ""
@hash_tag = ""
@caption = ""

@main_text = ""
@secondary_text = ""
@additional_text =  ""

def write_html_for_multi_image_post
  image_urls =  Dir["#{@file_name}/*"]
  @fileHtml = File.new("output/#{@file_name}.html", "w+")
  write_head_html

  @fileHtml.puts <<-HTML_TOP
    <div id='header'>
     <img id='logo_image' src='../images/main_logo.jpg' />
     <h1 id='title'>#{@title}</h1>
    </div>

     <div id='pictures_container'>
      <ul>

    HTML_TOP

  image_urls.each do |image_url|
    @fileHtml.puts <<-HTML_2
    <li>
    <div class='circle_background'>
      <div class='white_circle_background'>
        <img class='circle_image' src='../#{image_url}' />
      </div>
    </div>
    <h5>#{image_url.split("/")[1].split(".")[0].gsub("_", " ")}</h5>
    </li>
    HTML_2
  end

  @fileHtml.puts "</ul>"
  @fileHtml.puts "</div>"

  write_footer_html

  @fileHtml.close()
end
#PLEASE DONT BREAK

def write_html_for_word_post
  @fileHtml = File.new("output/#{@file_name}.html", "w+")
  write_head_html
  @fileHtml.puts <<-HTML_1
    <div id="header_word">
      <img id='logo_image_word' src='../images/main_logo.jpg' />
    </div>
    <div class="center">
    HTML_1
      @fileHtml.puts "<div id='main_text'><h1>#{@main_text}</h1></div>" unless @main_text == ""
      @fileHtml.puts "<div id='secondary_text'><h2>#{@secondary_text}</h2></div>" unless @secondary_text == ""
      @fileHtml.puts "<p id='additional_text'>#{@additional_text}</p>" unless @additional_text == ""
    @fileHtml.puts "</div>"
    write_footer_html
  @fileHtml.close()
end

def write_head_html
  @fileHtml.puts <<-HTML_1
       <HTML>
       <HEAD>
       <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
       <link rel='stylesheet' type='text/css' href='../styles.css' />

       <title>#{@title}</title
       </HEAD>
       <BODY>
       HTML_1
end

def write_footer_html
   @fileHtml.puts <<-HTML_3

    <div id='footer'>
    <div id='url'>#{@@url}</div>
    <div id='hash_tag'>\##{@hash_tag}</div>
    </div>
    </BODY>
    </HTML>

    HTML_3
end

def convert_html_to_png
  puts "building file"
  # HTML TO PNG
  new_html_file_path = "output/" + @file_name + ".html"
  kit = IMGKit.new(File.new(new_html_file_path), :quality => 1000)

  # # Get the image BLOB
  img = kit.to_img

  # # New in 1.3!
  img = kit.to_img(:png)      #default


  # # Save the image to a file
  image_file_name = @file_name + ".png"
  file = kit.to_file("output/" + image_file_name)
  puts "==============="
  puts "Done baking meme"
  puts "Check out your boy..."
  sleep(1)
  puts "..."
  sleep(1)
  puts "..."
  sleep(1)
  puts "..."
end

def print_intro_text
  intro_art = <<-HEREDOC

    ─────███────██
    ──────████───███
    ────────████──███
    ─────────████─█████
    ████████──█████████
    ████████████████████
    ████████████████████
    █████████████████████
    █████████████████████
    █████████████████████
    ██─────██████████████
    ███────────█████████
    █──█───────────████
    █──────────────██
    ██──────────────█────────▄███████▄
    ██───███▄▄──▄▄███──────▄██$█████$██▄
    ██──█▀───▀███────█───▄██$█████████$██▄
    ██──█───█──██───█─█──█$█████████████$█
    ██──█──────██─────█──█████████████████
    ██──██────██▀█───█─────██████████████
    ─█───██████──▀████───────███████████
    ──────────────────█───────█████████
    ─────────────▀▀████──────███████████
    ────────────────█▀──────██───████▀─▀█
    ────────────────▀█──────█─────▀█▀───█
    ──▄▄▄▄▄▄▄────────██────█───████▀───██
    ─█████████████────▀█──█───███▀──▄▄██
    ─█▀██▀██▀████▀█████▀──█───██████▀─▀█
    ─█────────█▄─────────██───████▀───██
    ─██▄████▄──██────────██───██──▄▄▄██
    ──██▄▄▄▄▄██▀─────────██──█████▀───█
    ─────────███────────███████▄────███
    ────────███████─────█████████████
    ───────▄██████████████████████
    ████████─██████████████████
    ─────────██████████████
    ────────███████████
    ───────█████
    ──────████
    ─────████

  HEREDOC

  puts intro_art
  puts "Welcome to Meme Maker Pro 2017"
end

def get_input_for_multi_image_post
  # Get Input data
  input_confirmed = false

  until  input_confirmed
    puts "What's the folder name? Ex: folder_name"
    @file_name = gets.chomp
    puts "What's the title? Press return to auto generate."
    @title_input = gets.chomp
    if @title_input == ""
      @title = @file_name.split("_").map { |w| w.capitalize }.join(" ")
    else
      @title = @title_input
    end

    puts "What's the hash tag?"
    @hash_tag = gets.chomp 
    @hash_tag = @file_name.gsub("_", "") if @hash_tag == ""

    puts "What's the caption?"
    @caption = gets.chomp
    puts "============INUPTS=============="
    puts "file_name: #{@file_name}"
    puts "title: #{@title}"
    puts "hash_tag: #{@hash_tag}"
    puts "caption: #{@caption}"
    puts "title is auto-generated"
    puts "...."
    puts "Is this correct? [Y/N] type 'exit' to exit"
    input = gets.chomp
    exit if input.downcase == 'exit'
    input_confirmed = true if input.downcase == "y"
    system "clear" or system "cls" unless input_confirmed
  end
end

def get_input_word_post

  input_confirmed = false

  until input_confirmed
      
    puts "What's the main text?"
    @main_text = gets.chomp
    @file_name = @main_text.gsub(" ", "_")

    @title = @file_name

    puts "What's the secondary_text text?"
    @secondary_text = gets.chomp

    puts "What's the additional text?"
    @additional_text = gets.chomp

    puts "What's the hash tag?"
    @hash_tag = gets.chomp 
    @hash_tag = @file_name.gsub("_", "") if @hash_tag == ""

    puts "What's the caption?"
    @caption = gets.chomp


    puts "============INUPTS=============="
    puts "main_text: #{@main_text}"
    puts "secondary_text: #{@secondary_text}"
    puts "hash_tag: #{@hash_tag}"
    puts "additional_text: #{@additional_text}"
    puts "caption: #{@caption}"
    puts "Is this correct? [Y/N] type 'exit' to exit"
    input = gets.chomp
    exit if input.downcase == 'exit'
    input_confirmed = true if input.downcase == "y"
    system "clear" or system "cls" unless input_confirmed
  end
end


def push_image_to_facebook
  puts "Do you want to push to Facebook? [Y/N]"
  push_to_facebook = gets.chomp
  if push_to_facebook.downcase == "y"
    # formatted_@caption = ERB::Util.url_encode(@caption)
    error = false
    begin
    post_url = @@FACEBOOK_GRAPH_POST_PHOTO_URL
    file_path = "output/" + @file_name + ".png"
    photo_file = File.new(file_path)
    response = RestClient.post(post_url, 
                          :access_token => @@FACEBOOK_TOKEN,
                          :caption => @caption,
                          :source => File.new(photo_file))
    rescue => e
      binding.pry
      response_hash = JSON[e.response.body]
      error = true
      puts "There was a problem."
      puts "======================================"
      puts "Error Message => #{response_hash["error"]["message"]}"
      puts "Go to:"
      puts "https://developers.facebook.com/tools/explorer/"
      puts "to get a new key"
    end
    if error
      "There was a problem and your post was not uploaded."
      
    else
      puts "Sent to Facebook!"
      puts "Great meme dood."
    end
  else
    puts "Not sharing."
    puts "Goodbye."
  end
end


def start_program
  print_intro_text

  type_confirmed = false

  until type_confirmed
    puts "Do you want to create a multi image photo or a word photo?"
    puts "[1] multi image, [2] word photo, [exit] to exit."
    type_select = gets.chomp

    if type_select == "1"
      type_confirmed = true
      get_input_for_multi_image_post
      write_html_for_multi_image_post
    elsif type_select == "2"
      type_confirmed = true
      get_input_word_post
      write_html_for_word_post
    elsif type_select == "exit"
      exit
    end
  end
  convert_html_to_png
  push_image_to_facebook
end


start_program

