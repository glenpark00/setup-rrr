######## OLD VERSION ########

function setup-react-redux {
  # These conditionals handle the source folder/entry file names (default: frontend, entry_file.jsx)
  # Note that if you want to change the default name of only the entry file, you still need to pass in a first argument for source folder
  if [[ -z "$1" ]] 
  then 
    source_folder=frontend
  else
    source_folder=$1
  fi
  if [[ -z "$2" ]] 
  then 
    entry_file=entry_file.jsx
  else
    entry_file=$2
  fi
  # Installing all of the necessary dependencies; --save means we will save it to package.json, and --save-dev will save the package as a devDependency
  npm init -y
  npm install react react-dom redux react-redux --save
  npm install @babel/core @babel/preset-env @babel/preset-react babel-loader webpack webpack-cli --save-dev
  # Create the .gitignore file so that node_modules won't be pushed to github (huge folder)
  echo node-modules/ > .gitignore
  # Creates and writes to webpack.config.js, using the correct source folder and entry file
  echo "const path = require('path');\n\nmodule.exports = {\n\tentry: './$source_folder/$entry_file',\n\toutput: {\n\t\tpath: path.resolve(__dirname),\n\t\tfilename: 'bundle.js'\n\t},\n\tmodule: {\n\t\trules: [\n\t\t\t{\n\t\t\t\ttest: /\.jsx?$/,\n\t\t\t\texclude: /(node_modules)/,\n\t\t\t\tuse: {\n\t\t\t\t\tloader: 'babel-loader',\n\t\t\t\t\tquery: {\n\t\t\t\t\t\tpresets: ['@babel/env', '@babel/react']\n\t\t\t\t\t}\n\t\t\t\t},\n\t\t\t}\n\t\t]\n\t},\n\tresolve: {\n\t\textensions: ['.js', '.jsx', '*']\n\t},\n\tdevtool: 'source-map'\n};" > webpack.config.js
  # Creates and writes to index.html; note that bundle.js (default webpack output file) is included in a script tag, as well as minified jQuery
  echo '<!DOCTYPE html>\n<html lang="en">\n\n<head>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t<title>Widgets</title>\n\t<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>\n\t<script src="./bundle.js"></script>\n</head>\n\n<body>\n\t<div id="root"></div>\n</body>\n\n</html>' > index.html
  # Creates the source folder and puts the entry file in it
  mkdir $source_folder
  cd $source_folder
  touch $entry_file

  # MAYBE MAKE AN ARGUMENT TO SAY IF THIS IS A REDUX PROJECT (do something like -pure for the argument and check if its there)
  mkdir actions
  mkdir components
  mkdir reducers
  mkdir store
  mkdir util

  cd ..
  # Adds the script to run webpack in package.json and runs the script
  jq '.scripts.webpack="webpack --watch --mode=development"' package.json | sponge package.json
  npm run webpack # MAYBE ADD A NEW ARG TO SAY IF YOU WANT TO OPEN WEBPACK, ALSO ADD STUFF FOR RAILS/REDUX
}


# MAYBE CHANGE THE ORDER OF THE ARGS SINCE ENTRY FILE WILL MOSTLY BE CHANGED, MAYBE TAKE OUT JQUERY TOO UNLESS AJAX COMES UP, AND ADD bundle.js and bundle.js.map (maybe package-lock.json too) to gitignore
# MAYBE CHANGE SO THAT THIS ACTUALLY MAKES A NEW PROJECT FOLDER AS WELL

function setup-react-redux {
  # These conditionals handle the source folder/entry file names (default: frontend, entry_file.jsx)
  # Note that if you want to change the default name of only the entry file, you still need to pass in a first argument for source folder
  if [[ -z "$1" ]] 
  then 
    source_folder=frontend
  else
    source_folder=$1
  fi
  if [[ -z "$2" ]] 
  then 
    entry_file=entry_file.jsx
  else
    entry_file=$2
  fi
  # Installing all of the necessary dependencies; --save means we will save it to package.json, and --save-dev will save the package as a devDependency
  npm init -y
  npm install react react-dom redux react-redux --save
  npm install @babel/core @babel/preset-env @babel/preset-react babel-loader webpack webpack-cli --save-dev
  # Create the .gitignore file so that node_modules won't be pushed to github (huge folder)
  echo node-modules/ > .gitignore
  # Creates and writes to webpack.config.js, using the correct source folder and entry file
  echo "const path = require('path');\n\nmodule.exports = {\n\tentry: './$source_folder/$entry_file',\n\toutput: {\n\t\tpath: path.resolve(__dirname),\n\t\tfilename: 'bundle.js'\n\t},\n\tmodule: {\n\t\trules: [\n\t\t\t{\n\t\t\t\ttest: /\.jsx?$/,\n\t\t\t\texclude: /(node_modules)/,\n\t\t\t\tuse: {\n\t\t\t\t\tloader: 'babel-loader',\n\t\t\t\t\tquery: {\n\t\t\t\t\t\tpresets: ['@babel/env', '@babel/react']\n\t\t\t\t\t}\n\t\t\t\t},\n\t\t\t}\n\t\t]\n\t},\n\tresolve: {\n\t\textensions: ['.js', '.jsx', '*']\n\t},\n\tdevtool: 'source-map'\n};" > webpack.config.js
  # Creates and writes to index.html; note that bundle.js (default webpack output file) is included in a script tag, as well as minified jQuery
  echo '<!DOCTYPE html>\n<html lang="en">\n\n<head>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t<title>Widgets</title>\n\t<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>\n\t<script src="./bundle.js"></script>\n</head>\n\n<body>\n\t<div id="root"></div>\n</body>\n\n</html>' > index.html
  # Creates the source folder and puts the entry file in it
  mkdir $source_folder
  cd $source_folder
  # touch $entry_file
  echo 'import React from "react";\nimport ReactDOM from "react-dom";\nimport Root from "./components/root";\nimport configureStore from "./store/store";\n\ndocument.addEventListener("DOMContentLoaded", () => {\n\tconst store = configureStore();
  
  \n\tReactDOM.render(<Root store={store}/>, root);\n})' > $entry_file

  # MAYBE MAKE AN ARGUMENT TO SAY IF THIS IS A REDUX PROJECT (do something like -pure for the argument and check if its there)
  mkdir actions
  mkdir components
  echo 'import React from "react";\n\nconst App = () => {\n\treturn(\n\t\t<div>\n\n\t\t</div>\n\t)\n};\n\nexport default App;' > components/app.jsx
  echo 'import React from "react";\nimport { Provider } from "react-redux";\nimport App from "./app";\n\nconst Root = ({ store }) =>(\n\t<Provider store={store}>\n\t\t<App />\n\t</Provider>\n);\n\nexport default Root;' > components/root.jsx
  mkdir reducers
  echo 'import {combineReducers} from "redux";\n\nconst rootReducer = combineReducers({\n\n})\n\nexport default rootReducer;' > reducers/root_reducer.js
  mkdir store
  echo 'import { createStore } from "redux";\nimport rootReducer from "../reducers/root_reducer";\n\nconst configureStore = (preloadedState = {}) => (\n\tconst configureStore = (preloadedState = {}) => {\n\treturn createStore(\n\t\trootReducer,\n\t\tpreloadedState\n\n\t
  
  return store;
}' > store/store.js
  mkdir util

  cd ..
  # Adds the script to run webpack in package.json and runs the script
  jq '.scripts.webpack="webpack --watch --mode=development"' package.json | sponge package.json
  npm run webpack # MAYBE ADD A NEW ARG TO SAY IF YOU WANT TO OPEN WEBPACK, ALSO ADD STUFF FOR RAILS/REDUX
}