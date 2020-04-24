function setup-rrr {
  # These conditionals handle the source folder/entry file names (default: frontend, entry_file), and sets the name of your Rails project to the project_name variable
  # Note that if you want to change the default name of only the source folder, you still need to pass in a first argument for entry file
  project_name=$1
  if [[ -z "$2" ]] 
  then 
    entry_file=entry_file.jsx
  else
    entry_file="${2}.jsx"
  fi
  if [[ -z "$3" ]] 
  then 
    source_folder=frontend
  else
    source_folder=$3
  fi
  
  # Create a new Rails 5.2.3 project with name of the first argument, and installs all the gems
  rails _5.2.3_ new $project_name -G -d=postgresql --skip-turbolinks
  cd $project_name

  # Adds a bunch of useful/necessary gems and installs all of the gems in the Gemfile
  gem1='"jquery-rails"'
  gem2='"annotate"'
  gem3='"pry-rails"'
  gem4='"better_errors"'
  gem5='"binding_of_caller"'
  perl -i -lpe "print '# Additional gems:' if $. == 37" Gemfile
  perl -i -lpe "print 'gem ${gem1}' if $. == 38" Gemfile
  perl -i -lpe "print '' if $. == 39" Gemfile
  perl -i -lpe "print '  # Additional gems:' if $. == 51" Gemfile
  perl -i -lpe "print '  gem ${gem2}' if $. == 52" Gemfile
  perl -i -lpe "print '  gem ${gem3}' if $. == 53" Gemfile
  perl -i -lpe "print '  gem ${gem4}' if $. == 54" Gemfile
  perl -i -lpe "print '  gem ${gem5}' if $. == 55" Gemfile
  bundle install
  # Note that the perl command does not support escaped tabs, so I manually put two spaces to mimic a tab in the last five commands; sorry to all you four space tabbers out there!

  # Uses perl to in-place edit the application.js file to include the jqeury sprocket
  perl -i -lpe 'print "//= require jquery" if $. == 14' app/assets/javascripts/application.js

  # Adds a line in config/environment.rb to automatically camelize the keys of the JSON outputted from Jbuilder
  echo '\n# Converts JBuilder keys to camelCase\nJbuilder.key_format camelize: :lower' >> config/environment.rb

  # Create the .gitignore file so that node-modules and bundle.js won't be pushed to github
  echo 'node-modules/\napp/assets/javascripts/bundle.js\napp/assets/javascripts/bundle.js.map' > .gitignore

  # Creates and writes to webpack.config.js, using the correct source folder and entry file
  echo "const path = require('path');\n\nmodule.exports = {\n\tentry: './$source_folder/$entry_file',\n\toutput: {\n\t\tpath: path.resolve(__dirname, 'app', 'assets', 'javascripts'),\n\t\tfilename: 'bundle.js'\n\t},\n\tmodule: {\n\t\trules: [\n\t\t\t{\n\t\t\t\ttest: /\.jsx?$/,\n\t\t\t\texclude: /(node_modules)/,\n\t\t\t\tuse: {\n\t\t\t\t\tloader: 'babel-loader',\n\t\t\t\t\tquery: {\n\t\t\t\t\t\tpresets: ['@babel/env', '@babel/react']\n\t\t\t\t\t}\n\t\t\t\t},\n\t\t\t}\n\t\t]\n\t},\n\tresolve: {\n\t\textensions: ['.js', '.jsx', '*']\n\t},\n\tdevtool: 'source-map'\n};" > webpack.config.js

  # Creates the source folder and puts the entry file in it
  mkdir $source_folder
  echo 'import React from "react";\nimport ReactDOM from "react-dom";\nimport Root from "./components/root";\nimport configureStore from "./store/store";\n\ndocument.addEventListener("DOMContentLoaded", () => {\n\tconst store = configureStore();\n\n\tconst root = document.getElementById("root");\n\tReactDOM.render(<Root store={store}/>, root);\n})' > $source_folder/$entry_file

  # Creates the actions, components, reducers, store, and util directories in the source folder, and adds some rudimentary files to them
  mkdir $source_folder/actions
  mkdir $source_folder/components
  echo "import React from 'react';\n\nconst App = () => (\n\t<div>\n\t\t<h1>$project_name Homepage</h1>\n\t</div>\n);\n\nexport default App;" > $source_folder/components/app.jsx  
  echo 'import React from "react";\nimport { Provider } from "react-redux";\nimport { HashRouter } from "react-router-dom";\nimport App from "./app";\n\nconst Root = ({ store }) =>(\n\t<Provider store={store}>\n\t\t<HashRouter>\n\t\t\t<App />\n\t\t</HashRouter>\n\t</Provider>\n);\n\nexport default Root;' > $source_folder/components/root.jsx
  mkdir $source_folder/reducers
  echo 'import { combineReducers } from "redux";\n\nconst entitiesReducer = combineReducers({\n\n});\n\nexport default entitiesReducer;' > $source_folder/reducers/entities_reducer.js
  echo 'import { combineReducers } from "redux";\n\nconst errorsReducer = combineReducers({\n\n});\n\nexport default errorsReducer;' > $source_folder/reducers/errors_reducer.js
  echo 'import { combineReducers } from "redux";\n\nconst uiReducer = combineReducers({\n\n});\n\nexport default uiReducer;' > $source_folder/reducers/ui_reducer.js
  echo 'import { combineReducers } from "redux";\nimport rootReducer from "./root_reducer.js"\nimport entitiesReducer from "./entities_reducer";\nimport uiReducer from "./ui_reducer";\n\nconst rootReducer = combineReducers({\n\tentities: entitiesReducer,\n\terrors: errorsReducer,\n\tui: uiReducer\n})\n\nexport default rootReducer;' > $source_folder/reducers/root_reducer.js
  mkdir $source_folder/store
  echo 'import { createStore, applyMiddleware } from "redux";\nimport rootReducer from "../reducers/root_reducer";\nimport thunk from "redux-thunk";\nimport logger from "redux-logger";\n\nconst configureStore = (preloadedState = {}) => (\n\tcreateStore(\n\t\trootReducer,\n\t\tpreloadedState,\n\t\tapplyMiddleware(thunk, logger)\n\t)\n)\n\nexport default configureStore;' > $source_folder/store/store.js
  mkdir $source_folder/util

  # Installing all of the necessary dependencies; --save means we will save it to package.json, and --save-dev will save the package as a devDependency
  npm init -y
  npm install react react-dom react-router-dom react-redux redux redux-thunk --save
  npm install @babel/core @babel/preset-env @babel/preset-react babel-loader redux-logger webpack webpack-cli --save-dev

  # Adds the script to run webpack in package.json and runs the script
  jq '.scripts.webpack="webpack --watch --mode=development"' package.json | sponge package.json
  npm run webpack
} 