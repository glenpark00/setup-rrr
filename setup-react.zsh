function setup-react {
  # These conditionals handle the source folder/entry file names (default: frontend, entry_file), and sets the name of your React project to the project_name variable
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
  # Creates the project directory
  mkdir $project_name
  cd $project_name
  # Installing all of the necessary dependencies; --save means we will save it to package.json, and --save-dev will save the package as a devDependency
  npm init -y
  npm install react react-dom --save
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
  cd ..
  # Adds the script to run webpack in package.json and runs the script
  jq '.scripts.webpack="webpack --watch --mode=development"' package.json | sponge package.json
  npm run webpack
}