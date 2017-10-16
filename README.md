⚠️ There's **no `rake`** for this exercise. Sorry 😉

So now we want to enhance our cookbook by finding recipes from the web. We will use
[🇫🇷 Marmiton](http://www.marmiton.org) or [🇬🇧 LetsCookFrench](http://www.letscookfrench.com), because their markup structure is pretty clean (making them good candidates for parsing). If you want to choose another recipe website, please go ahead! It just needs to have a **search** feature where the search keywords are passed in the [query string](https://en.wikipedia.org/wiki/Query_string).

## Setup

You will add your HTML scraper feature to your already existing app (from Friday). You can copy & paste your old code and put it into today's folder with this command (don't forget to copy the trailing dot!):

```bash
cp -r ../../03-Cookbook-Day-One/01-Cookbook/lib .
```

It will add fill the lib folder with your previous code from which you can start. You can also take the solution from the livecode (cf. Slack).

Before starting on today, run your pasted cookbook to make sure that the basic user actions (list / add / remove) are working!

```bash
ruby lib/app.rb
```

## 1 - (User action) Import recipes from the web

You can scrape from any recipe website that you know, but good ones are [Epicurious](http://www.epicurious.com/), [LetsCookFrench](http://www.letscookfrench.com/) and [Marmiton](http://www.marmiton.org/) for the french speakers. Here's how this feature should work:

```
-- My CookBook --
What do you want to do?

1. List all recipes
2. Add a recipe
3. Delete a recipe
4. Import recipes from LetsCookFrench
5. Exit

> 4
What ingredient would you like a recipe for?
> strawberry

Looking for "strawberry" on LetsCookFrench...
10 results found!

1. Strawberry shortcake
2. Strawberry slushie
3. Strawberry martini
[...]

Please type a number to choose which recipe to import
> 2
Importing "Strawberry slushie"...
```

### Pseudo-code

For this new **user action** (hence new _route_), we need to:

1. Ask a user for a keyword to search
2. Make an HTTP request to the recipe's website with our keyword
3. Parse the HTML document to extract the useful recipe info
4. Display a list of recipes found to the user
5. Ask the user which number recipe they want to import
6. (Optional) Make a new HTTP request to fetch more info (description, cooking time, etc.) from the recipe page
7. Add the chosen recipe to the `Cookbook`

### Analyze the page markup

First, let's have a look at how we'll retrieve information from the Web.

You can save an HTML document on your computer through `curl` command. Get the following HTML page saved as a `.html` file in your working directory by running one of these two commands in the terminal:

```bash
curl --silent 'http://www.marmiton.org/recettes/recherche.aspx?aqt=fraise' > fraise.html
curl --silent 'http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=strawberry' > strawberry.html
```

👆 **This step is really important**!

The reason why we keep the page on our hard drive is that we need to run Ruby scripts over it hundreds of times to test our code. It's much faster to open the file on disk rather than making a network call to Marmiton/LetsCookFrench every time (that would probably also get us blacklisted).

### Parsing with Nokogiri

Nokogiri is a cool and famous gem used to parse HTML documents (it does other stuff too!) Here is how you can use it to parse a document once you know the CSS selectors of the elements you are interested in. CSS selectors will be explained later, but the gist of it is that you can select all elements with a given `class` attribute by creating the query `.class`.

For instance, if you want to find all elements with the `student` class in the following HTML, you will use the query `".student"`

```html
<ul>
  <li class="student">John</li>
  <li>Paul</li>
  <li class="student">Ringo</li>
</ul>
```

You can use the following boilerplate code to start:

```ruby
require 'nokogiri'
file = 'fraise.html'  # or 'strawberry.html'
doc = Nokogiri::HTML(File.open(file), nil, 'utf-8')

# Up to you to find the relevant CSS query.
```

You can work in a dedicated webfile, `parsing.rb` for instance. Try to extract the recipe names. In the beginning, you can just `puts` the information extracted.

**Resource**: here's a [good starting point for Nokogiri](https://www.sitepoint.com/nokogiri-fundamentals-extract-html-web/).

### Get response HTML data using `open-uri`

Time to use your parsing code on a live URL with different queries (not just `[fraise|strawberry]`). Use the [open-uri](http://www.ruby-doc.org/stdlib/libdoc/open-uri/rdoc/OpenURI.html) library to get the HTML response from a given URI:

```ruby
require 'nokogiri'
require 'open-uri'
url = "http://the_url_here"
doc = Nokogiri::HTML(open(url), nil, 'utf-8')

# Rest of the code
```

### `Controller` / `View` / `Router`

Once you have this parsing logic, time to add this new user action in your `Controller`. Use the pseudo-code above as a guide of this new method. For your first attempt, you can copy-paste the working parsing code into your controller.

Think about the **class** that should be used to hold information parsed from the web, what is it?

Try it live running your Cookbook!

## 3 - Add a `@cooking_time` property to `Recipe`

This new property should be:

- Stored in the CSV
- Parsed from the web when importing a recipe
- Printed when listing the recipes

## 4 - (User Action) Mark a recipe as done

Once you're done with the "Search", try to add a feature to mark a recipe as tested:

```
-- Here are all your recipes --

1. [X] Crumpets (15 min)
2. [ ] Beans & Bacon breakfast (45 min)
3. [X] Plum pudding (90 min)
4. [X] Apple pie (60 min)
5. [ ] Christmas crumble (30 min)
```

## 5 - Add a `@difficulty` property to `Recipe`

Again, this new property should be stored in the CSV and displayed when listing recipes.

Try modifying the web-import feature so that you can import recipes with a given difficulty (you might want to make this argument optional keeping the old import feature possible).

## 6 - (Optional) Service

Try to extract the **parsing** logic out of the controller and put it into a [**Service Object**](http://brewhouse.io/blog/2014/04/30/gourmet-service-objects.html):

```ruby
class ScrapeLetsCookFrenchService # or ScrapeMarmitonService
  def initialize(keyword)
    @keyword = keyword
  end

  def call
    # TODO: return a list of `Recipes` built from scraping the web.
  end
end
```

## 7 - (Optional) Web Application

Terminal apps are cool, but you know what's cooler? Web applications! Let's try to port our Cookbook to a new web application using the `sinatra` gem. Here's a [101 on Sinatra](https://github.com/lewagon/sinatra-101#readme) to start working on that.
