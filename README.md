# poe-atlas-tool
Work-in-progress tool to aid PoE atlas completion. <br />

Features will include: (Partially inspired by [this reddit post](https://www.reddit.com/r/pathofexiledev/comments/86ezft/map_exchange_helper/))
* Allow users to screenshot atlas and generate list of complete/incomplete maps
    * Generate poe.trade links and trade messages to assist bulk-buying
        * e.g. @User Hi, I would like to buy your Strand map listed for 1 alch (+Other T4 if you have them: Canyon, Chateau, Lighthouse, Relic Chambers) 
* (maybe) Provide utility to keep track of users' atlas progress and provide a trade tool
## Usage
For now,
  1. Open coordinates-test/test.html
  2. Select a (borderless) fullscreen screenshot of your atlas
  3. Results are printed to console (can verify results by comparing the output array length to the in-game completion counter)
  
## Development setup
    # Install dependencies
    bundle install
    yarn install
    
    # Set up database
    rake db:migrate
    rake db:seed
    
    # Run server
    ruby .\bin\webpack-dev-server
    rails s
    
## Production setup
    # Install dependencies
    bundle install
    yarn install
    
    # Set up rails master key (unused for now)
    rails credentials:edit
    
    # Set up database
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production rake db:seed
    
    # Compile assets
    rake assets:clobber
    rake assets:precompile
    
    # Run server (no nginx)
    rails s -e production -p80
    
    # Run server (nginx)
    # Config in puma.rb
    rails s -e production